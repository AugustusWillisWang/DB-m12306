# -*- coding: UTF-8 -*-
import csv

all_station_file=r'G:\workpath\DB-m12306\src\database\setup_db\all-stations.txt'

def setup_SCI_dict():
    global SCI_dict
    SCI_dict={}
    global SID_dict
    SID_dict={}

    with open(all_station_file, encoding='utf-8') as f:
        f_csv = csv.reader(f)
        # headers = next(f_csv)
        for row in f_csv:
            SCI_dict[str(row[1])]=[int(row[0]),str(row[2])]
            SID_dict[int(row[0])]=[str(row[1]),str(row[2])]
            
def SCI_dict_ready():
    if SCI_dict['抚顺北']==[1255, '抚顺']:
        print('city_projection imported successfully.')
        return 1
    else:
        print('city_projection import failed.')
        return 0

def sid_to_cname(sid):
    return SID_dict[int(sid)][1]

def sname_to_sid(sname):
    return SCI_dict[sname][0]

def sname_to_cname(sname):
    return SCI_dict[sname][1]

if __name__=='__main__':
    setup_SCI_dict()
    SCI_dict_ready()
    print('Should be: [1255, \'抚顺\']')
    print(SCI_dict['抚顺北'])