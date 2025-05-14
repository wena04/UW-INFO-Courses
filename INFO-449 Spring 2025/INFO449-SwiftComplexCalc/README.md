# ComplexCalc
This exercise is designed to test your ability to work with functions as first-class citizens in the Swift programming language, as well as a few other constructs in Swift (such as tuples and maps).

Your task is simple: Make the code compile, and make all the test expressions (unit tests) return true (pass). You may not change the tests that already exist; you may, however, add a few tests, as well.

## To get started...
... you must first obtain a copy of the source. You do that by cloning this repository. Two options are available to you:

1. **Fork this repository.** From the GitHub repository web page, click "Fork" in the upper-right. This will create a copy of this repository in your own GitHub account. From there do a `git clone` from your own copy of the GitHub repository. (If you are unsure of the clone syntax, open the new repository in your account from the web, and click the green "Code" button--it will offer the correct syntax to use.)

2. **Clone and re-home this repository.** Open a "Command Prompt" or "Terminal" instance and use:

        git clone https://github.com/tedneward/INFO449-SwiftComplexCalc

    ... to do the deed. This will also create a local copy of the project on your machine in a directory called `INFO449-SwiftComplexCalc`. You will also need to "re-home" your local copy so it points to your own GitHub account; you can do this by creating a repository of this same name (`INFO449-SwiftComplexCalc`) in your GitHub account and then executing `git remote set-url origin https://github.com/[your-ID]/INFO449-SwiftComplexCalc.git`. (Needless to say, it's a lot easier to fork the repo.)

    In order to store your changes to your own GitHub account, you need to create a new repository on GitHub (call it `swiftcomplexcalc`), and then change the project's settings to point to that new repository as the remote origin.

        git remote set-url origin https://github.com/[your-ID]/INFO449-SwiftComplexCalc.git

    Note, this will appear to succeed whether you got the syntax of the URL correct or not, so do a quick push to make sure it all worked correctly:

        git push

    Git will ask you for your username and password, then (if everything was done correctly), it will upload the code to the new repository, and this is your new "home" for this project going forward. Verify the files are there by viewing your GitHub project through the browser.

## To work with the code...
The code contained in this project is an XCode Playground (similar to the last assignment). Open it in XCode. It will **NOT** run--there are compile errors that you must fix before anything can run. If you wish, you can comment out the tests so that the Playground will run--however, the tests must run for you to get any credit for the assignment, so be sure to uncomment them again!

> PRO TIP: When working with a new codebase, commenting out sections of code so that you can focus on a smaller part of the problem is a common trick. Then, as you make changes--such as adding an `add` method to Calculator--uncomment that particular set of tests to make sure your code matches what's in the test and does what it's supposed to do.

Remember that Git uses a two-step process: first you must `commit` the code to your local copy of the repository, and then you must `push` the code from your local repository to the remote server (GitHub). Always check the website if there's any doubt--what's on the server is all that matters.

Now, you can begin to work on the homework code.

## Your tasks
The simple calculator you explored in the previous assignment was a smashing success with Upper Management, and they want more. Specifically, they want a version of it in a nicely self-contained class that they can import everywhere they need calculation capabilities throughout the enterprise. This is a mission-critical project!

> PRO TIP: Not really.

Your job, then, is to create a Calculator class that performs the canonical operations of a calculator (add, subtract, multiply, etc) as well as a few other operations. 

In fact, knowing that Upper Management always has things going on that they don't tell you about, part of the goal is to make the calculator a little more flexible than the creators intended, and able to provide calculation using custom-built operations that the Calculator doesn't know about. In order to do that, the Calculator will be using "higher-order functions" to carry out its operations.

> PRO TIP: Don't always assume this when you get into the Real World (TM); sometimes they do, sometimes they don't, but adding a bunch of extensibility and additional features to code that isn't something the customer actually wants is known as "gold-plating" the code, and is just as much of a problem as not delivering what the customer actually wants.

Additionally, certain mathematical operations (add, multiply) support more than two parameters, which we should also support. These will take arrays of Integers as the single parameter.

On top of that, we should be able to perform some operations on some different data types, such as Cartesian points (x,y pairs), so our Calculator will need to support those as well. (Implementation note: by the use of the word "pairs" here, I mean to use tuples--specifically, `Int,Int` tuples. Two-element tuples are commonly called "pairs", three-element tuples are sometimes called "triplets", and four-element tuples are sometimes called "quads". If you get to a five-element tuple, you have a problem, just create a class or a struct and be done with it.)

And, because your instructor is an evil, evil man, we also want the Calculator to be able to add and subtract Cartesian points represented in `String-to-Int` dictionaries (maps), as well.

All of these will be backed by tests in the Playground code, so that you can know whether your code is working according to specification or not. You are free to look at the tests (they're right below the big comment line), but you may not modify them. If you want to add to them, that's acceptable, so long as you do it in the space provided.

> PRO TIP: It is strongly suggested that as you get each test working, commit your code to GitHub. Each time you get a little bit working, commit to GitHub. It is far, far easier for I and the TA to figure out where something went wrong and get you partial credit if we have a commit history to examine, as opposed to a "commit everything when I'm done" style that college students so often prefer. It's easier on your boss, too, when you get to a Real Job, if you have a rich commit history; on top of that, if you have something working, commit it, then make a change and the whole world seems to blow up, you can always revert back to that previous place of goodness and start over. Can't do that unless you commit regularly, though.
