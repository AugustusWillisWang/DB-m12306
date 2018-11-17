import re

def subtime(last, former):
    pattern=re.compile(r'([0-9]+?)\:([0-9]+?)$')
    a=re.match(pattern,last)
    na=int(a.group(1))*60+int(a.group(2))
    b=re.match(pattern,former)
    nb=int(b.group(1))*60+int(b.group(2))
    return na-nb

