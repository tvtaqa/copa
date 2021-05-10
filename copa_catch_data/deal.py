# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    resList = []
    tpsList = []
    cnt = 0
    with open("dealed_log.txt", "r") as f:  # 打开文件
        for line in f.readlines():
            num = line.strip()
            if cnt % 2 == 0:
                resList.append(num)
            else:
                tpsList.append(num)
            cnt = cnt + 1
        pass
    pass
    print(resList)
    print(tpsList)
    cycle =0
    last = resList[0]
    for i in resList:
        if last == i:
            last = i
            cycle = cycle + 1
        else:
            break
        pass
    pass
    stripRes = []
    averTps = []
    readIndex = 0
    tmpSum = 0
    while readIndex < len(tpsList):
        tmpSum = tmpSum + float(tpsList[readIndex])
        if (readIndex+1) % 3 is 0:
            stripRes.append(resList[readIndex])
            averTps.append(tmpSum/3)
            tmpSum = 0
        pass
        readIndex = readIndex + 1
    pass
    print(averTps)
    print(stripRes)

    filename = 'ms_data.txt'
    tmpIndex = 0
    with open(filename, 'w') as file_object:
        while tmpIndex < len(averTps):
            file_object.write(stripRes[tmpIndex])
            file_object.write(" ")
            file_object.write(str(averTps[tmpIndex]))
            file_object.write("\n")
            tmpIndex = tmpIndex + 1
        pass
    pass


