# 导入openpyxl库
import openpyxl
import xlsxwriter

# 导入os库
import os


print(os.getcwd())
path = './'
os.system('sh stream.sh')


def get_value(file, keyword):
    with open(file) as f:
        # 以每行的形式读取文件并设置为变量infos
        readlines = f.readlines()
        value=1
        # read = readlines.split().split("")
        for readline in readlines:
            if readline.find(keyword) != -1:
                line = readline.split()
                value = line[1]
    return value


if os.path.exists(path + 'report/stream/' + 'stream.xlsx'):
    os.system('rm -rf ./report/stream/stream.xlsx')

workbook = xlsxwriter.Workbook(path+'report/stream/'+'stream.xlsx')  # 新建excel表

worksheet = workbook.add_worksheet('stream')  # 新建sheet（sheet的名称为"sheet1"
headings = ['测试项', '测试说明', '测试数据']  # 设置表头
test_name = ['Copy', 'Scale', 'Add', 'Triad']
explain = ['静态内存读写带宽', '静态内存读写乘法操作带宽', '静态内存读写加法操作带宽', '静态内存读写混合操作带宽']

file1 = path + 'report/stream/'+'单线程.txt'
file2 = path + 'report/stream/'+'满线程.txt'

copy1 = get_value(file1, 'Copy')
print(copy1)
scale1 = get_value(file1, 'Scale')
add1 = get_value(file1, 'Add')
traid1 = get_value(file1, 'Triad')

copy2 = get_value(file2, 'Copy')
scale2 = get_value(file2, 'Scale')
add2 = get_value(file2, 'Add')
traid2 = get_value(file2, 'Triad')

test_type = ['单线程', '满线程']
worksheet.write_row('A1', headings)
worksheet.write('A2', test_type[0])
worksheet.write_column('A3', test_name)
worksheet.write('A7', test_type[1])
worksheet.write_column('A8', test_name)
worksheet.write_column('B3', explain)
worksheet.write_column('B8', explain)
worksheet.write('C3', copy1)
worksheet.write('C4', scale1)
worksheet.write('C5', add1)
worksheet.write('C6', traid1)
worksheet.write('C8', copy2)
worksheet.write('C9', scale2)
worksheet.write('C10', add2)
worksheet.write('C11', traid2)

workbook.close()

pwd=os.getcwd()
report_path= pwd +'/report/stream'
print("测试完成，请在%s目录下查看结果" %report_path)
