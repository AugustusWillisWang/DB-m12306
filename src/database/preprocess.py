import re
import csv
import argparse

testa = []
testa.append(
    r'1,      太原,         -,     19:10,          ,         0,         0,       -/-,           -/-/-,           -/-')
testa.append(
    r'2,      榆次,     19:31,     19:36,       5分,        21,        27,       7/-,        53/58/61,     78.5/84.5')
testa.append(r'24,    兰州西,     15:04,         -,          ,      1194,      1344,   152.5/-,272.5/284.5/291.5,   434.5/454.5')

# 创建一个解析对象
parser = argparse.ArgumentParser(
    prog='preprocess', usage='preprocess -f filename')
# parser.add_argument("echo",help=" echo the string you use here!")
# 向对象中添加相关命令行参数或选项,每一个add_argument方法对应一个参数或选项
parser.add_argument('-f', '--filename',
                    help="input the train csv file name", type=str)
# 调用parse_args()方法进行解析
args = parser.parse_args()


def main(new_filename):
    with open(new_filename, 'wb') as output:  # 打开方式还可以使用file对象
        writer = csv.writer(output)
        with open(filename) as f:
            reader = csv.reader(f)
            first=1
            for row in reader:
                if first:
                    first=0
                    writer.writerow(['站号','站名','到时','发时','停留','历时','里程','硬座','软座','硬卧上','硬卧中','硬卧下','软卧上','软卧下'])
                    continue
                y = re.match(
                    r'''\s*([0-9]*)\,\s*(.+?)\,\s+ (.+?)\,\s+ (.+?)\,\s+(.*?)\,\s+(.*?)\,\s+(.*?)\,\s+ (.+?)\/(.+?)\,\s*(.+?)\/(.+?)\/(.+?)\,\s*(.+?)\/(.+?)$''', row)
                m = list(y.groups())
                if(m[2] == '-'):
                    m[2] = '0:00'
                if(m[3] == '-'):
                    m[3] = '0:00'
                for i in range(len(m)):
                    if m[i] == '-':
                        m[i] = '0'
                writer.writerow(m.groups())
                        # print(m.groups())


def test():
    print(['站号','站名','到时','发时','停留','历时','里程','硬座','软座','硬卧上','硬卧中','硬卧下','软卧上','软卧下'])
    for row in testa:
        # m = re.match(r'''
        #     \s*([0-9]*)\,
        #     \s*?(.+?)\,
        #     \s+ (.+?)\,
        #     \s+ (.+?)\,
        #     \s+ (.+?)\,
        #     \s+ (.+?)\,
        #     \s+ (.+?)\/
        #     (.+?)\,
        #     (.+?)\/
        #     (.+?)\/
        #     (.+?)\,
        #     (.+?)\/
        #     (.+?)'''
        # , row)
        # print(row)
        y = re.match(
            r'''\s*([0-9]*)\,\s*(.+?)\,\s+ (.+?)\,\s+ (.+?)\,\s+(.*?)\,\s+(.*?)\,\s+(.*?)\,\s+ (.+?)\/(.+?)\,\s*(.+?)\/(.+?)\/(.+?)\,\s*(.+?)\/(.+)$''', row)
        m = list(y.groups())
        if(m[2] == '-'):
            m[2] = '0:00'
        if(m[3] == '-'):
            m[3] = '0:00'
        for i in range(len(m)):
            if m[i] == '-':
                m[i] = '0'
        print(m)


if __name__ == "__main__":
    test()
    exit()
    filename = args.filename
    new_filename = filename
    print('filename:', filename)
    print('new_filename:', new_filename)
    new_filename = "t_"+new_filename

    main(new_filename)
