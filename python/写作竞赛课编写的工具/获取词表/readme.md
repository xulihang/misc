用制表符重新排列antconc的lemma表

基于获取的web文本提取生词或所有单词

将所得结果进行频率统计，删除重复项

调用朗道词典给词表加上中文释义

# 使用方法：

生成生词表：

`python getNewWords_based_on_lemma_saving_upper_case.py 文本文件`

生成有词频的词表，输出在out/total.txt

`python frequency.py`

基于上面的词表添加中文解释（需要词典）

`python addExplaination.py total.txt `