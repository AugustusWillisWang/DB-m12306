# -*- coding: UTF-8 -*-
import preprocess
import os

path = r"C:\Users\autum\Desktop\data\all" #文件夹目录
files= os.listdir(path) #得到文件夹下的所有文件名称
s = []
for file in files: #遍历文件夹
     if not os.path.isdir(file): #判断是否是文件夹，不是文件夹才打开
          with open(path+'\\'+file, encoding='utf-8') as f: #打开文件
              print(path+'\\'+file)
              preprocess.do_pre_process(f,file)