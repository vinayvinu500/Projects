
"""Numpy Edition"""
"""
import numpy as np
import os 

#Formation of Tic Tac Toe
# physical representation of Board of sample and original
# user input of 'X' or 'O'
# update the physical representation of Board

# components of Tic Tac Toe
r1 = ['*', '*', '*']
r2 = ['*', '*', '*']
r3 = ['*', '*', '*']
t = np.array([r1, r2, r3])
d = {1: (0, 0), 2: (0, 1), 3: (0, 2), 4: (1, 0), 5: (1, 1), 6: (1, 2), 7: (2, 0), 8: (2, 1), 9: (2, 2)}
flip = ('X', 'O', 'X', 'O', 'X', 'O', 'X', 'O', 'X')


# representation of Tic Tac Toe
def rep():
    print('                                      ')
    print('     ========Warning!=======        ')
    print(" ")
    print('Note: the numbers in sample is the placeholder to put "X" or "O" in Original')
    print('     ========Sample=========        ')
    print('          ', [1, 2, 3])
    print('          ', [4, 5, 6])
    print('          ', [7, 8, 9])
    print('')
    print('     =======Original========       ')
    # print(t)
    print('       ', r1)
    print('       ', r2)
    print('       ', r3)
    print('          ')


# positional board to place 'X' or 'O'
def pos(n, v):
    global r1, r2, r3
    x, y = d[n]
    if t[x, y] == '*':
        t[x, y] = v
    else:
        return True
    r1 = [t[0, 0], t[0, 1], t[0, 2]]
    r2 = [t[1, 0], t[1, 1], t[1, 2]]
    r3 = [t[2, 0], t[2, 1], t[2, 2]]
    return False


# check linear and diagonal of X or O
def check(a, b, c):
    if a == 'X' and b == 'X' and c == 'X':
        print('                                      ')
        print('     =======>      "X" Win\'s     <=======     ')
        return True
    elif a == 'O' and b == 'O' and c == 'O':
        print('                                      ')
        print('     =======>     "O" Win\'s     <=======     ')
        return True



def wise():
    # row wise
    if check(t[0, 0], t[0, 1], t[0, 2]):
        print('     =======>      First Row     <=======     ')
        return True
    if check(t[1, 0], t[1, 1], t[1, 2]):
        print('     =======>      Second Row    <=======     ')
        return True
    if check(t[2, 0], t[2, 1], t[2, 2]):
        print('     =======>      Third Row     <=======     ')
        return True

    # column wise
    if check(t[0, 0], t[1, 0], t[2, 0]):
        print('     =======>    First Column    <=======     ')
        return True
    if check(t[0, 1], t[1, 1], t[2, 1]):
        print('     =======>    Second Column   <=======     ')
        return True
    if check(t[0, 2], t[1, 2], t[2, 2]):
        print('     =======>    Third Column    <=======     ')
        return True

    # diagonal wise
    if check(t[0, 0], t[1, 1], t[2, 2]):
        print('     =======>      Diagonal      <=======     ')
        return True
    if check(t[0, 2], t[1, 1], t[2, 0]):
        print('     =======>      Diagonal      <=======     ')
        return True



# representation of tic tac toe
for i in range(0, 9):
    try:
        rep()
        print('     =====Your Turn\'s=======       ')
        print(f'     =======> "{flip[i]}" <=========     ')
        print('                                      ')
        num = int(input('Select a number from sample: '))
        val = flip[i]
        os.system('clear')
        if pos(num, val):
            print('                                      ')
            print('     =======>      Warning!     <=======     ')
            print('     ===> Entered Same Number Twice <===   ')
            print('                                      ')
            break
        elif wise():
            print('                                      ')
            print('              ', r1)
            print('              ', r2)
            print('              ', r3)
            print('              ')
            break
        elif i == 8:
            print('                                      ')
            print('              ', r1)
            print('              ', r2)
            print('              ', r3)
            print('              ')
            print('     ======>     It\'s a Draw     <======     ')
    except (ValueError,KeyError):
        print('                                      ')
        print('     =======>   Unknown Input!  <=======     ')
        print('                                      ')
        break

print('     ======>   ...Game Over...   <======     ')
print('                                      ')
print('     =====> Designed by Vinayvinu <=====     ')

"""
"""Without Numpy Module to prevent imported and Imported Error should be terminated"""

"""Tic Tac Toe"""
"""
r1 = ['*', '*', '*']
r2 = ['*', '*', '*']
r3 = ['*', '*', '*']
d = {1: (r1, 0), 2: (r1, 1), 3: (r1, 2), 4: (r2, 0), 5: (r2, 1), 6: (r2, 2), 7: (r3, 0), 8: (r3, 1), 9: (r3, 2)}
flip = ('X', 'O', 'X', 'O', 'X', 'O', 'X', 'O', 'X')
row = ''
index = 0


# representation of Tic Tac Toe
def rep():
    print('                                 ')
    print('     =====> Warning!  <=====     ')
    print('\n     Note:\n       The numbers in Sample\n       Is the Placeholder')
    print('       To put "X" or "O"\n       In Original')
    print('                                 ')
    print('     ======> Sample  <======     ')
    print('           ', [1, 2, 3])
    print('           ', [4, 5, 6])
    print('           ', [7, 8, 9])
    print('                                 ')
    print('     =====>  Original <=====     ')
    print('        ', r1)
    print('        ', r2)
    print('        ', r3)
    print('            ')


# positional board to place 'X' or 'O'
def pos(n, v):
    global row, index
    x, y = d[n]
    row = x
    index = y
    if row[index] == '*':
        row[index] = v
    else:
        return True
    return False


# check linear and diagonal of X or O
def check(a, b, c):
    if a == 'X' and b == 'X' and c == 'X':
        print('                                  ')
        print('     =====> "X" Win\'s <=====     ')
        return True
    elif a == 'O' and b == 'O' and c == 'O':
        print('                                  ')
        print('     =====> "O" Win\'s <=====     ')
        return True



def wise():
    # row wise
    if check(r1[0], r1[1], r1[2]):
        print('     =====> First Row <=====    ')
        return True
    if check(r2[0], r2[1], r2[2]):
        print('     =====> Second Row <====    ')
        return True
    if check(r3[0], r3[1], r3[2]):
        print('     =====> Third Row <=====    ')
        return True

    # column wise
    if check(r1[0], r2[0], r3[0]):
        print('     ====> First Column <===   ')
        return True
    if check(r1[1], r2[1], r3[1]):
        print('     ===> Second Column <===   ')
        return True
    if check(r1[2], r2[2], r3[2]):
        print('     ====> Third Column <===   ')
        return True

    # diagonal wise
    if check(r1[0], r2[1], r3[2]):
        print('     ====>  Diagonal  <=====   ')
        return True
    if check(r1[2], r2[1], r3[0]):
        print('     ====>  Diagonal  <=====   ')
        return True


# representation of tic tac toe
for i in range(0, 9):
    try:
        # virtual representation
        rep()
        print('     =====> Your Turn <=====              ')
        print(f'     =====>    "{flip[i]}"    <=====     ')
        print('                                          ')
        num = int(input('     =====> Place Number: '))
        val = flip[i]
        # positional representation
        if pos(num, val):
            print('                               ')
            print('     =====> Warning!  <=====   ')
            print('     ====> Same Number <====   ')
            print('     ===> Entered Twice <===   ')
            print('                               ')
            break
        # check's representation
        elif wise():
            print('            ')
            print('        ', r1)
            print('        ', r2)
            print('        ', r3)
            print('            ')
            break
        # draw's representation
        elif i == 8:
            print('            ')
            print('        ', r1)
            print('        ', r2)
            print('        ', r3)
            print('            ')
            print('     ====> It\'s a Draw <====     ')
    except (ValueError,KeyError):
        print('                               ')
        print('     =====> Warning!  <=====   ')
        print('     ===> Unknown Input! <==   ')
        print('                               ')
        break

print('     ===>...Game Over...<===     ')
print('                                 ')
print('     =====> Designed  <=====     ')
print('     =====>    by     <=====     ')
print('     =====> Vinayvinu <=====     ')
# Build atleast 6 hrs with successful Error free and Testing...
print('                                 ')
"""
"""
# formation of Tic Tac Toe Game 
# first appearance
# ask which side 'X' or 'O'
# player turn show 
tic = "
           |       |
      {a}  |  {b}  |  {c}
           |       |
      --------------------
           |       |
      {d}  |  {e}  |  {f}
           |       |
      --------------------
           |       |
      {g}  |  {h}  |  {i}
           |       |
".format(a=0,b=0,c=0,d=0,e=0,f=0,g=0,h=0,i=0)
"""


#======================================================================================================================================================#
"""Building Tic Tac Toe Game"""

"""components"""
v = ['X', 'O']
# ' ' or 'X' or 'O'
r1 = [' ', ' ', ' ',]
r2 = [' ', ' ', ' ',]
r3 = [' ', ' ', ' ',]
d = {1: (r1, 0), 2: (r1, 1), 3: (r1, 2), 4: (r2, 0), 5: (r2, 1), 6: (r2, 2), 7: (r3, 0), 8: (r3, 1), 9: (r3, 2)}
row = ' '
ind = ' '


# Starting the Game

# representation
def rep():
    print('                          ')
    print('      ==> Tic Tac Toe  <== ')
    print('                          ')
    print("      =======sample=======")
    print("      ||    1 | 2 | 3   ||")
    print("      ||  ------------- ||")
    print("      ||    4 | 5 | 6   ||")
    print("      ||  ------------- ||")
    print("      ||    7 | 8 | 9   ||")
    print("      ====================")
    print('                          ')
    print('                          ')
    print(f"            |       |\n        {r1[0]}   |   {r1[1]}   |   {r1[2]}\n            |       |\n")
    print('      ----------------------')
    print(f"            |       |\n        {r2[0]}   |   {r2[1]}   |   {r2[2]}\n            |       |\n")
    print('      ----------------------')
    print(f"            |       |\n        {r3[0]}   |   {r3[1]}   |   {r3[2]}\n            |       |\n")


# accepting user input of numbers
def user():
    try:
        x = 99
        while x not in list(range(0, 10)):
            rep()
            x = int(input("      Enter Number: "))
            if x in list(range(1,10)):
                print('\n' * 100)
                return x
            else:
                print('\n'*100)
                print('                               ')
                print('     =====> Warning!  <=====   ')
                print('           Wrong Input!        ')
                print('                               ')
                return False
    except ValueError:
        print('\n'*100)
        print('                               ')
        print('     =====>  Warning!  <=====  ')
        print('           Wrong Input!        ')
        print('                               ')
        return False
    return x


# accepting player choice of "X"or"O"
def player():
    global v
    a = ''
    while a not in v:
        print("      Welcome to Tic Tac Toe!")
        a = input('           "X" \./ "O"\n                ').upper()
        if a not in v:
            print('                               ')
            print('     =====>  Warning!  <=====  ')
            print('           Wrong Input!        ')
            print('                               ')
            print('\n'*100)
    if a == 'X':
        v = v * 5
        v.pop()
        print('\n' * 100)
    elif a == 'O':
        v.reverse()
        v = v * 5
        v.pop()
        print('\n' * 100)


# positional representation
def pos(n,o):
    global row,ind
    g,h = d[n]
    row,ind = g,h
    if row[ind] == ' ':
        g[h] = o
        return False
    else:
        print('\n'*100)
        print('                               ')
        print('     =====> Warning!  <=====   ')
        print('     ====> Same Number <====   ')
        print('     ===> Entered Twice <===   ')
        print('                               ')
        return True

# check linear and diagonal of X or O
def check(a, b, c):
    if a == 'X' and b == 'X' and c == 'X':
        print('                                  ')
        print('     =====> "X" Win\'s <=====     ')
        return True
    elif a == 'O' and b == 'O' and c == 'O':
        print('                                  ')
        print('     =====> "O" Win\'s <=====     ')
        return True


def wise():
    # row wise
    if check(r1[0], r1[1], r1[2]):
        print('     =====> First Row <=====    ')
        return True
    if check(r2[0], r2[1], r2[2]):
        print('     =====> Second Row <====    ')
        return True
    if check(r3[0], r3[1], r3[2]):
        print('     =====> Third Row <=====    ')
        return True

    # column wise
    if check(r1[0], r2[0], r3[0]):
        print('     ====> First Column <===   ')
        return True
    if check(r1[1], r2[1], r3[1]):
        print('     ===> Second Column <===   ')
        return True
    if check(r1[2], r2[2], r3[2]):
        print('     ====> Third Column <===   ')
        return True

    # diagonal wise
    if check(r1[0], r2[1], r3[2]):
        print('     ====>  Diagonal  <=====   ')
        return True
    if check(r1[2], r2[1], r3[0]):
        print('     ====>  Diagonal  <=====   ')
        return True
    return False


# result
player()
for i in range(1, 10):
    if i == 9:
        rep()
        print('     ====> It\'s a Draw <====     ')
        break
    elif wise():
        print('                                                                                            ')
        print(f"            |       |\n        {r1[0]}   |   {r1[1]}   |   {r1[2]}\n            |       |\n")
        print('      ----------------------')
        print(f"            |       |\n        {r2[0]}   |   {r2[1]}   |   {r2[2]}\n            |       |\n")
        print('      ----------------------')
        print(f"            |       |\n        {r3[0]}   |   {r3[1]}   |   {r3[2]}\n            |       |\n")
        break
    # rep()
    print('     ====> Your Turn <====              ')
    print(f'     ====>    "{v[i]}"    <====        ')
    print('                                        ')
    u = user()
    while u is False:
        u = user()
    p = pos(u,v[i])
    while p is True:
        u = user()
        p = pos(u,v[i])
    # break

print('     ===>...Game Over...<===     ')
print('     ===>Thank you....<3<===     ')
# print('                                 ')
# print('     =====> Designed  <=====     ')
# print('     =====>    by     <=====     ')
# print('     =====> Vinayvinu <=====     ')
# Build atleast 6 hrs with successful Error free and Testing...