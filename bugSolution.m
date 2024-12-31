To address these issues, use `__weak` references within blocks whenever possible, to avoid creating retain cycles.  For delegates, ensuring proper lifecycle management and using `weak` references are crucial.

```objectivec
// Solution for the first example: using a __weak reference
@property (nonatomic, strong) NSMutableArray *myArray;

- (void)someMethod {
    __weak typeof(self) weakSelf = self; // Create a weak reference to self
    [self.myArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;  // Create a strong reference only when needed
        if (strongSelf) { //Check if the object is still alive
            // ... some code that modifies obj ...
        }
    }];
}

//Solution for the second example: using weak delegate
@protocol MyDelegate <NSObject>
- (void)myDataChanged:(MyDataObject *)data;
@end

@property (nonatomic, weak) id <MyDelegate> delegate;

- (void)someOtherMethod {
    MyDataObject *data = [MyDataObject new];
    if (self.delegate) {  // Check if the delegate exists
        [self.delegate myDataChanged:data];
    }
}
```

By using `__weak` references and checking for `nil` before using the objects, we ensure that we don't access deallocated memory, preventing crashes.