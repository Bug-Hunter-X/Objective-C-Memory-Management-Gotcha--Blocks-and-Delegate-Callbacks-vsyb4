In Objective-C, a common yet subtle issue arises when dealing with memory management and object lifecycles, especially when using blocks.  Consider this scenario:

```objectivec
@property (nonatomic, strong) NSMutableArray *myArray;

- (void)someMethod {
    [self.myArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // ... some code that modifies obj ...
    }];
}
```

If `obj` is modified within the block in a way that changes its retain count (e.g., adding it to another array with a strong reference), and the original `myArray` is subsequently released before the block completes, you'll get a crash.  The object referenced by `obj` might be deallocated prematurely, leading to an unexpected EXC_BAD_ACCESS.

Another similar situation occurs with delegate callbacks:

```objectivec
@protocol MyDelegate <NSObject>
- (void)myDataChanged:(MyDataObject *)data;
@end

@property (nonatomic, weak) id <MyDelegate> delegate;

- (void)someOtherMethod {
    MyDataObject *data = [MyDataObject new];
    [self.delegate myDataChanged:data];
}
```
If `self.delegate` is nil or deallocates before the delegate method completes, the application may crash or exhibit undefined behavior because `data` might be accessed after being deallocated.