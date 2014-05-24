# Transparent Runtime Proof of Concept

This POC application demonstrates the structure of a transparent runtime that uses objective c runtime’s [“associated objects”][associated-objects] to pair up a runtime observer class to perform [“key value observing”][key-value-observing] on a data model object.

[associated-objects]: http://nshipster.com/associated-objects/
[key-v.alue-observing]: http://nshipster.com/key-value-observing/


## Project Overview

This proof of concept leverages features from modern objective-c to hide the metadata and machinery needed to track an objective-c class. The tracked class in this example is a simple data model object. Aside from a single call to register with the runtime (which could be a conditional macro), the data model object contains no additional support code.


Three classes demonstrate the structure of this runtime concept.
- The "Subject" is the class being observed.  It contains a few simple properties and code to create a meaningful description.  It could be used with or without the runtime.  For this example, it includes a call in the `-(id)init` method to automaticly register with the runtime.
- The "Runtime" is not so much a class as it is a namespace wrapper in this example.  It is not created as an instance, instead, its' class methods are used to interact with the runtime.  It allows one to write descriptive code like `[TSTRuntime registerWithRuntime:object]` and keep the global namespace clean.  
- The "Observer" class contains data members that represent the metadata tracked by the runtime. It also includes the implementation of "key value observing" for the object it observes.  This allows the runtime to be transparent in the sense that registered classes, consumers of those classes, and other libraries are unaware of the runtimes existance.


The runtime works by creating and associating an "Observer" to the registered "Subject".  Subsequent calls to the runtime query the "Subject" for its associated "Observer" to extract the information needed by the runtime. Through this association, the management of the "Observers" instance memory is tied to the "Subject" object. When the "Subject" is deallocated, it will deallocate all assocaited objects including its' "Observer". 

The "Subject" objects and the code that interacts with them have no visibility of the "Observer".  Modifications to the "Subject" through key value coding compliant methods (like the ones created by the compiler for properties) are seen by the "Observer" through key value observing.  This may be used track values, modification state, or request action from the runtime.



 





