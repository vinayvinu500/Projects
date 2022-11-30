import subprocess
import sys


def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

install('mysql-connector-python')
install('numpy')
install('pandas')

import datetime
import math
import os

import mysql.connector
import numpy as np
import pandas as pd

passw = input('Enter password for MySQL: ') # 2214
path = input('Enter path for bike_dataset: ') # 'P:\\Downloads\\bike_dataset'

# create database
try:
    db = mysql.connector.connect(host='localhost',
                                 user='root',
                                 password=passw)
except:
    # db.close()  # if anything happens
    print('Not Connected!')
else:
    print("bike databse created Successfully!", db)
    cursor = db.cursor()
    cursor.execute('drop database if exists bike;')
    cursor.execute('create database if not exists bike;')


# sql connector
try:
    db = mysql.connector.connect(host='localhost',
                                 user='root',
                                 password=passw,
                                 db='bike')
except:
    db.close()  # if anything happens
    print('Not Connected!')
else:
    print("Connected!", db,'\n')
    cursor = db.cursor()

# os : current directory
print('previous directory: ',os.getcwd())
os.chdir(path) # 'P:\\Downloads\\bike_dataset'
print('current directory: ',os.getcwd(),'\n')

# csv files
l = sorted([i for i in os.listdir() if i.endswith('.csv')])
print('Files need to be pushed into bike database\n')
[print(i) for i in l] # printing csv files


# table structure
def table_structure(df):
    col = ''
    for j, i in enumerate(df.columns):
        s = ''
        if df[i].dtype == 'object':
            s = max([len(str(i)) for i in df[i].values]) + 1  # varchar(size)
            s = f'{i} varchar({s}), '
        else:
            # d,m = math.modf()
            d = max([len(str(math.modf(i)[0]).replace('.0', ''))
                    for i in df[i].values])+1  # real
            m = max([len(str(math.modf(i)[0]).replace('.0', ''))
                    for i in df[i].values])+1  # precision
            s = f'{i} float({m+d}), '

        if j == 0:
            s = '('+s
            col += s
        elif j == len(df.columns)-1:
            s = s.rstrip() + ');'
            col += s.replace(',', '')
        else:
            col += s
    return col

rows = 0
print('#=============== Query Execution Started! ======================#')
# create a tables
for i in l:
    df = pd.read_csv(i)
    d = datetime.date(int(i[:4]), int(i[4:6]), 1).strftime('%b')
    s = table_structure(df)

    query = f'create table if not exists {i[:4]}_{d}{s}'
    cursor.execute(query)
    print(f'Query OK, {i[:4]}_{d} table created!')
else:
    print()


# insert values
for i in l:
    # structure
    df = pd.read_csv(i)
    d = datetime.date(int(i[:4]), int(i[4:6]), 1).strftime('%b')
    s = ', '.join(df.columns.values)

    # values
    v = ', '.join(["%s"]*df.columns.size)
    query = f'insert into {i[:4]}_{d}({s}) values({v})'
    values = [tuple(x) for x in df.fillna(
        np.nan).replace([np.nan], [None]).to_numpy()]

    cursor.executemany(query, values)
    db.commit()
    print(f'Query OK, Table: {i[:4]}_{d} has {df.shape[0]} rows inserted!')
    rows += df.shape[0] # total rows
else:
    print('#=============== Query Execution End Successfully! ======================#')

# Additional checks
for i in l:
    df = pd.read_csv(i)
    d = datetime.date(int(i[:4]), int(i[4:6]), 1).strftime('%b')
    query = """Select count(*) from """+f'2021_{d};'
    cursor.execute(query)
    result = cursor.fetchone()
    check = f'Table: 2021_{d} has "{result[0]}" rows successfully converted!' if result[
        0] == df.shape[0] else f'2021_{d} Failure'
    print(i+' => '+check)
    # need to work in terms of error
    # if result[0] == df.shape[0]:
    #     break
else:
    print('Total rows :',rows,'Pushed!')
    # close session
    cursor.close()
    db.close()


'''
# select all the tables
SELECT CONCAT('select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from`', table_name, '` limit 30;')
FROM information_schema.tables
WHERE table_schema = 'bike';

# query to execute
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Apr` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Aug` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Dec` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Feb` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Jan` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Jul` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Jun` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Mar` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_May` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Nov` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Oct` limit 30;
select ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name from `2021_Sep` limit 30;   


select count(distinct ride_id),count(ride_id) from `2021_Apr`; 
select count(distinct ride_id),count(ride_id) from `2021_Aug`; 
select count(distinct ride_id),count(ride_id) from `2021_Dec`; 
select count(distinct ride_id),count(ride_id) from `2021_Feb`; 
select count(distinct ride_id),count(ride_id) from `2021_Jan`; 
select count(distinct ride_id),count(ride_id) from `2021_Jul`; 
select count(distinct ride_id),count(ride_id) from `2021_Jun`; 
select count(distinct ride_id),count(ride_id) from `2021_Mar`; 
select count(distinct ride_id),count(ride_id) from `2021_May`; 
select count(distinct ride_id),count(ride_id) from `2021_Nov`; 
select count(distinct ride_id),count(ride_id) from `2021_Oct`; 
select count(distinct ride_id),count(ride_id) from `2021_Sep`;   
'''
