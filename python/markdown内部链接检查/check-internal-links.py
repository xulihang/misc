import os
import re
import csv
from pathlib import Path
import unicodedata

def extract_links_from_markdown(md_file_path):
    """Extract all internal links from a Markdown file.
    
    Args:
        md_file_path (str): Path to the Markdown file
        
    Returns:
        list: List of tuples containing (link_text, link_url, line_number)
    """
    internal_links = []
    link_pattern = r'\[([^\]]+)\]\(([^)]+)\)'  # Pattern for [text](url)
    
    with open(md_file_path, 'r', encoding='utf-8') as f:
        for line_num, line in enumerate(f, 1):
            matches = re.finditer(link_pattern, line)
            for match in matches:
                link_text, link_url = match.groups()
                # Check if it's an internal link (starts with / or is relative path)
                if link_url.startswith(('/','./','../')) or link_url.endswith('.md'):
                    internal_links.append((link_text, link_url, line_num))
    
    return internal_links

def check_anchor_in_file(file_path, anchor):
    """Check if an anchor exists in the specified file.
    
    Args:
        file_path (str): Path to the file to check
        anchor (str): Anchor to look for (without #)
        
    Returns:
        bool: True if anchor exists, False otherwise
    """
    if not os.path.exists(file_path):
        return False
    
    # Patterns for Markdown headers that might become anchors
    header_patterns = [
        r'^#+\s+(.*)$',          # # Header
        r'^.*\s*\{\#(.*)\}.*$',  # Header {#anchor}
    ]
    
    with open(file_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            for pattern in header_patterns:
                match = re.match(pattern, line)
                if match:
                    header_text = match.group(1).strip().lower()
                    # Convert header to likely anchor format
                    header_anchor = markdown_header_to_anchor(header_text)

                    if header_anchor == anchor.lower():
                        return True
    return False
    
def markdown_header_to_anchor(header_text):
    """
    Convert Markdown header text to HTML anchor text.
    Examples:
    - "DeviceObject.acquireImage()" → "deviceobjectacquireimage"
    - "`some_code` example" → "somecode-example"
    - "Dynamsoft.DWT.EnumDWT_PixelType" → "dynamsoftdwtenumdwt_pixeltype"
    """
    # Convert to lowercase
    anchor = header_text.lower()
    
    # Remove backticks (`) first
    anchor = anchor.replace('`', '')
    
    # Replace dots with nothing (to handle cases like Dynamsoft.DWT...)
    anchor = anchor.replace('.', '')
    
    # Remove punctuation except underscores and hyphens
    anchor = re.sub(r'[^\w\s_-]', '', anchor)
    
    # Replace spaces with hyphens
    anchor = re.sub(r'[\s]+', '-', anchor)
    
    # Remove consecutive hyphens (but preserve underscores)
    anchor = re.sub(r'-+', '-', anchor)
    
    # Strip hyphens/underscores from start/end (but keep internal ones)
    anchor = anchor.strip('-')
    
    # Convert Unicode to ASCII approximations
    anchor = unicodedata.normalize('NFKD', anchor).encode('ascii', 'ignore').decode('ascii')
    
    return anchor
    
def resolve_link_path(base_file_path, link_url, root_dir):
    """Resolve the absolute path of a link relative to the base file.
    
    Args:
        base_file_path (str): Path to the file containing the link
        link_url (str): The link URL to resolve
        root_dir (str): Root directory of the project
        
    Returns:
        tuple: (resolved_file_path, anchor) where anchor may be None
    """
    # Split anchor from path
    if '#' in link_url:
        path_part, anchor = link_url.split('#', 1)
    else:
        path_part = link_url
        anchor = None
    
    # Normalize path (handle ./ and ../)
    if path_part.startswith('/'):
        # Absolute path from root_dir
        resolved_path = os.path.normpath(os.path.join(root_dir, path_part.lstrip('/')))
    else:
        # Relative to containing file
        base_dir = os.path.dirname(base_file_path)
        resolved_path = os.path.normpath(os.path.join(base_dir, path_part))
    
    # Add .md extension if not present
    if not resolved_path.endswith('.md') and os.path.exists(resolved_path + '.md'):
        resolved_path += '.md'
    
    return resolved_path, anchor

def check_markdown_links(root_dir, output_csv):
    """Check all internal links in Markdown files within root_dir.
    
    Args:
        root_dir (str): Directory to search for Markdown files
        output_csv (str): Path to output CSV file
    """
    results = []
    md_files = []
    
    # Gather all Markdown files
    for root, _, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.md'):
                md_files.append(os.path.join(root, file))
    
    # Process each Markdown file
    for md_file in md_files:
        links = extract_links_from_markdown(md_file)
        for link_text, link_url, line_num in links:
            # Resolve the link path
            resolved_path, anchor = resolve_link_path(md_file, link_url, root_dir)

            # Check if file exists
            file_exists = os.path.exists(resolved_path)
            anchor_exists = False
            
            # If file exists and has anchor, check anchor
            if file_exists and anchor:
                anchor_exists = check_anchor_in_file(resolved_path, anchor)
            
            # Determine status
            if not file_exists:
                status = "FILE_NOT_FOUND"
            elif anchor and not anchor_exists:
                status = "ANCHOR_NOT_FOUND"
            else:
                status = "OK"
            
            # Add relative paths for cleaner output
            rel_md_file = os.path.relpath(md_file, root_dir)
            rel_resolved_path = os.path.relpath(resolved_path, root_dir) if file_exists else resolved_path
            
            results.append({
                'source_file': rel_md_file,
                'source_line': line_num,
                'link_text': link_text,
                'link_url': link_url,
                'target_file': rel_resolved_path,
                'anchor': anchor if anchor else '',
                'status': status
            })
    
    # Write results to CSV
    with open(output_csv, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=[
            'source_file', 'source_line', 'link_text', 'link_url', 
            'target_file', 'anchor', 'status'
        ])
        writer.writeheader()
        writer.writerows(results)
    
    print(f"Link check completed. Results saved to {output_csv}")

if __name__ == "__main__":
    # Configuration
    ROOT_DIR = "./"  # Directory containing Markdown files
    OUTPUT_CSV = "link_check_results.csv"  # Output CSV file
    
    # Run the check
    check_markdown_links(ROOT_DIR, OUTPUT_CSV)