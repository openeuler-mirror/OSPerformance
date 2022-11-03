# 导入openpyxl库
import openpyxl
import xlsxwriter

# 导入os库
import os

path = './'
# 调用执行测试系统的shell脚本
# os.chdir('stream')
os.system('sh stream.sh')

print(os.getcwd())


# 打开单线程.txt并设置为变量f
def get_stream_value(file_name, keyword):
    with open(file_name) as f:
        # 以每行的形式读取文件并设置为变量infos
        global value
        readlines = f.readlines()
        #print(readlines)
        # print(readlines)
        # read = readlines.split().split("")
        for readline in readlines:
            if readline.find(keyword) != -1:
                value = readline.split()[1]

            # if keyword in readline:
            # 以:切片，取出索引为0的值
            # neme = readline.split(":")[0]
            # 以空格切片，取出索引为1的值
            # value = readline.split()[1]

    return value


print("get_stream_value(path + 'report/stream_results/单线程.txt', 'Copy')")


def write_stream_excel(dict, row_1):
    ws.cell(row=row_1, column=1, value=dict['name'])
    ws.cell(row=row_1, column=2, value=dict['explain'])
    ws.cell(row=row_1, column=3, value=dict['stream_value'])


if os.path.exists(path + 'report/' + 'stream.xlsx'):
    os.system('rm -rf stream.xlsx')

# 新建一个工作薄
bw = openpyxl.Workbook()
# 激活表格
ws = bw.active
# 新建一个名称为netperf_sheet1的表单
ws.title = 'stream_sheet1'
title = "steam 测试结果"
headings = ['测试项', '测试说明', '测试数据']  # 设置表头
test_type = ['单线程', '满线程']

# 在表格的第一行第一列插入变量名为title值
ws.cell(row=1, column=1, value=title)
ws.cell(row=2, column=1, value=headings[0])
ws.cell(row=2, column=2, value=headings[1])
ws.cell(row=2, column=3, value=headings[2])
ws.cell(row=3, column=1, value=test_type[0])
ws.cell(row=8, column=1, value=test_type[1])

Copy_value1 = {'name': 'Copy',
               'explain': '静态内存读写带宽',
               'keyword': 'Copy',
               'file_name': path + 'report/stream_results/单线程.txt'
               }
Copy_value1['stream_value'] = get_stream_value(Copy_value1['file_name'], Copy_value1['keyword'])
#print(Copy_value1)

Scale_value1 = {'name': 'Scale',
                'explain': '静态内存读写乘法操作带宽',
                'keyword': 'Scale',
                'file_name': path + 'report/stream_results/单线程.txt'
                }
Scale_value1['stream_value'] = get_stream_value(Scale_value1['file_name'], Scale_value1['keyword'])
#print(Scale_value1)

Add_value1 = {'name': 'Add',
              'explain': '静态内存读写加法操作带宽',
              'keyword': 'Add',
              'file_name': path + 'report/stream_results/单线程.txt'
              }
Add_value1['stream_value'] = get_stream_value(Add_value1['file_name'], Add_value1['keyword'])

Traid_value1 = {'name': 'Traid',
                'explain': '静态内存读写混合操作带宽',
                'keyword': 'Traid',
                'file_name': path + 'report/stream_results/单线程.txt'
                }
Traid_value1['stream_value'] = get_stream_value(Traid_value1['file_name'], Traid_value1['keyword'])

#print(Traid_value1)

Copy_value2 = {'name': 'Copy',
               'explain': '静态内存读写带宽',
               'keyword': 'Copy',
               'file_name': path + 'report/stream_results/满线程.txt'
               }
Copy_value2['stream_value'] = get_stream_value(Copy_value2['file_name'], Copy_value2['keyword'])
print(Copy_value2)

Scale_value2 = {'name': 'Scale',
                'explain': '静态内存读写乘法操作带宽',
                'keyword': 'Scale',
                'file_name': path + 'report/stream_results/满线程.txt'
                }
Scale_value2['stream_value'] = get_stream_value(Scale_value2['file_name'], Scale_value2['keyword'])
#print(Scale_value2)

Add_value2 = {'name': 'Add',
              'explain': '静态内存读写加法操作带宽',
              'keyword': 'Add',
              'file_name': path + 'report/stream_results/满线程.txt'
              }
Add_value2['stream_value'] = get_stream_value(Add_value2['file_name'], Add_value2['keyword'])
#print(Add_value2)

Traid_value2 = {'name': 'Traid',
                'explain': '静态内存读写混合操作带宽',
                'keyword': 'Traid',
                'file_name': path + 'report/stream_results/满线程.txt'
                }
Traid_value2['stream_value'] = get_stream_value(Traid_value2['file_name'], Traid_value2['keyword'])

print(Traid_value2)

row = 4
write_stream_excel(Copy_value1, row)
row += 1
write_stream_excel(Scale_value1, row)
row += 1
write_stream_excel(Add_value1, row)
row += 1
write_stream_excel(Traid_value1, row)
row += 2
print(row)
write_stream_excel(Copy_value2, row)
print(row)
row += 1
write_stream_excel(Scale_value2, row)
row += 1
write_stream_excel(Add_value2, row)
row += 1
write_stream_excel(Traid_value2, row)

# # 保存表格
bw.save(path + 'report/' + 'stream.xlsx')
