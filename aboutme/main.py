from pandas import array


stringIn = 'My name is ryan'
def stringBreaker(stringIn):
    arrayOut = []
    spaceChar = ''
    for letterChar in stringIn:
        if letterChar == ' ':
            arrayOut.append(spaceChar)
            spaceChar = ''
        else:
            spaceChar += letterChar
    if spaceChar:
        arrayOut.append(spaceChar)
    return arrayOut

print(stringBreaker(stringIn))    