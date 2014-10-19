Esmeralda : Gesture Recognition for iOS made easy (Work in Progress)
=========

Esmeralda aims to recognize all kinds of gestures such as basic shapes, numbers, custom gestures and of course, the basic gestures. 

Implemented in Objective-C, basically it has three parts to consider:

1. EsmeraldaLibrary
2. BBDD
3. Gestures-BBDD.json


##1. EsmeraldaLibrary

This is the main file. It implements all the process of gesture recognition, compare with BBDD profiles and retrieve the gesture recognized.

The process for gesture recognition is a kNN algorithm, which basically it takes profiles X,Y from the gesture and using Euclidean distance with the BBDD, gets the minimum distance and determine what gesture is.

## 2. BBDD

This goal of this file is to read all "Gesture-BBDD.json" and store the data. This class is based on the Singleton pattern.

## 3. Gestures-BBDD.json

Finally this JSON is all the profiles from the BBDD previously created and parsed to create these profiles. At this moment, it only has information about circle (type:1), triangles(type:2) and squares(type:3)

In the future, the developer will enter on esmeralda website, choose the gestures he wants to recognise, and the website will generate him a JSON with the BBDD that he wants.

Work in Progress
========

* Improve the BBDD (more gestures and less size)
* Make this library as a subclass of UIGestureRecognizer
* Improve the recognition (try other distance like Chebishev distance), get more information about the gesture not only profiles
* Refactor coding

# IMPORTANT

This project is still in development so it cannot be used for real project at this moment. 




