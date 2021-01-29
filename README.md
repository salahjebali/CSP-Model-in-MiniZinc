# CSP-Model-in-MiniZinc
This project is a CSP model made in MiniZinc for the Artificial Intelligence exam from University of Florence, department of Computer Engineering. 


## Introduction

The program was written in MiniZinc language and builds a model for the generation
of an exam calendar that respects the constraints provided by the text of the exercise: the classrooms must be
large enough to accommodate the number of students enrolled for the exam; exams can't
being broken during the lunch break; each student can take at most one exam at
day. The generated model is generic enough to allow you to solve any one
instance. The tests performed check that, given a certain input instance, the calendar generated
is the one expected and that, therefore, respects the prescribed constraints. In addition, the times are compared
resolution of each instance.

## How to start 

First of all you need to download and install the MiniZinc compiler and the corresponding IDE at
from the site https://www.minizinc.org/software.html. Then you need to download the folder
containing the code and input data from https://github.com/salahjebali/CSP-Model-in-MiniZinc-.git.

## How to run it


1. Open MiniZinc IDE and open the exercise template_jebali.mzn contained in the folder 
   artificial_intelligence_exercise.
2. Open any data _ *.dzn file contained in the data folder.
3. Set Gecode 6.1.1 [built-in] as solver and press RUN.

### For more details you can find a full detailed report (italian only)



