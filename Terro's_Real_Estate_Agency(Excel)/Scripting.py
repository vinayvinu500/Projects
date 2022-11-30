# covariance matrix
CRIME_RATE = [8.516147873, 0.562915215, -0.110215175, 0.000625308, -0.229860488, -8.229322439, 0.068168906, 0.056117778,
              -0.882680362, 1.16201224]
AGE = [0.562915215, 790.7924728, 124.2678282, 2.381211931, 111.5499555, 2397.941723, 15.90542545, -4.74253803,
       120.8384405, -97.39615288]
INDUS = [-0.110215175, 124.2678282, 46.97142974, 0.605873943, 35.47971449, 831.7133331, 5.680854782, -1.884225427,
         29.52181125, -30.46050499]
NOX = [0.000625308, 2.381211931, 0.605873943, 0.013401099, 0.615710224, 13.02050236, 0.047303654, -0.024554826,
       0.487979871, -0.454512407]
DISTANCE = [-0.229860488, 111.5499555, 35.47971449, 0.615710224, 75.66653127, 1333.116741, 8.74340249, -1.281277391,
            30.32539213, -30.50083035]
TAX = [-8.229322439, 2397.941723, 831.7133331, 13.02050236, 1333.116741, 28348.6236, 167.8208221, -34.51510104,
       653.4206174, -724.8204284]
PTRATIO = [0.068168906, 15.90542545, 5.680854782, 0.047303654, 8.74340249, 167.8208221, 4.677726296, -0.539694518,
           5.771300243, -10.09067561]
AVG_ROOM = [0.056117778, -4.74253803, -1.884225427, -0.024554826, -1.281277391, -34.51510104, -0.539694518, 0.492695216,
            -3.073654967, 4.484565552]
LSTAT = [-0.882680362, 120.8384405, 29.52181125, 0.487979871, 30.32539213, 653.4206174, 5.771300243, -3.073654967,
         50.89397935, -48.35179219]
AVG_PRICE = [1.16201224, -97.39615288, -30.46050499, -0.454512407, -30.50083035, -724.8204284, -10.09067561,
             4.484565552, -48.35179219, 84.41955616]

# features indexing
d = {0: 'CRIME_RATE',
     1: 'AGE',
     2: 'INDUS',
     3: 'NOX',
     4: 'DISTANCE',
     5: 'TAX',
     6: 'PTRATIO',
     7: 'AVG_ROOM',
     8: 'LSTAT',
     9: 'AVG_PRICE'
     }

# Scripting
"""
Covariance of {i} and {Age} is {0.562915215} which depicts the magnitude of {1} and its states from zero to positive direction
Covariance of {i} and {Indus} is {-0.11021518} which depicts the magnitude of {0} and its states from negative to zero direction
Covariance of {i} and {Nox} is {-0.11021518} which depicts the magnitude of {0} and its states from negative to zero direction
Covariance of {i} and {Distance} is {-0.11021518} which depicts the magnitude of {0} and its states from negative to zero direction
Covariance of {i} and {Tax} is {-0.11021518} which depicts the magnitude of {0} and its states from negative to zero direction
Covariance of {i} and {PTRatio} is {-0.11021518} which depicts the magnitude of {0} and its states from negative to zero direction
Covariance of {i} and {AVG_ROOM} is {-0.11021518} which depicts the magnitude of {0} and its states from negative to zero direction
Covariance of {i} and {LSTAT} is {-0.11021518} which depicts the magnitude of {0} and its states from negative to zero direction
Covariance of {i} and {AVG_PRICE} is {-0.11021518} which depicts the magnitude of {0} and its states from negative to zero direction
"""

# input
# inp = [float(input()) for _ in range(10)]
# print(inp)

features = [CRIME_RATE,
            AGE,
            INDUS,
            NOX,
            DISTANCE,
            TAX,
            PTRATIO,
            AVG_ROOM,
            LSTAT,
            AVG_PRICE]


# number is in direction
def direction(n):
    if n < 0:
        return 'Negative'
    if n > 0:
        return 'Positive'
    return 'Zero'


# looping
# for j, k in enumerate(features[0]):
#     print(f"# {d[j]}")
#     print(f"""
#     Covariance of {d[j]} and Age is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction
#     # Covariance of {d[j]} and Indus is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction
#     # Covariance of {d[j]} and Nox is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction
#     # Covariance of {d[j]} and Distance is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction
#     # Covariance of {d[j]} and Tax is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction
#     # Covariance of {d[j]} and PTRatio is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction
#     # Covariance of {d[j]} and AVG_ROOM is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction
#     # Covariance of {d[j]} and LSTAT is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction
#     # Covariance of {d[j]} and AVG_PRICE is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction
#     #     """)


# looping
def sig(n):
    print(f"# {d[n]}")
    for j,k in enumerate(features[n]):
       if j == 0:
              print(f"Covariance of {d[n]} and CRIME_RATE is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction")
       if j == 1:
              print(f"Covariance of {d[n]} and Age is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction")
       if j == 2:
              print(f"Covariance of {d[n]} and Indus is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction")
       if j == 3:
              print(f"Covariance of {d[n]} and Nox is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction")
       if j == 4:
              print(f"Covariance of {d[n]} and Distance is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction")
       if j == 5:
              print(f"Covariance of {d[n]} and Tax is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction")
       if j == 6:
              print(f"Covariance of {d[n]} and PTRatio is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction")
       if j == 7:
              print(f"Covariance of {d[n]} and AVG_ROOM is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction")    
       if j == 8:
              print(f"Covariance of {d[n]} and LSTAT is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction")
       if j == 9:
              print(f"Covariance of {d[n]} and AVG_PRICE is {k} which depicts the magnitude of {round(k)} and its states from {direction(k)} to {direction(round(k))} direction")    
           
           

for i in range(10):
    sig(i)
    print()
