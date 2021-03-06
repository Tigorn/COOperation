// Copyright (c) 2016 RAMBLER&Co
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "OperationBufferImplementation.h"

@interface OperationBufferImplementation ()
@property (nonatomic, strong) id buffer;
@end

@implementation OperationBufferImplementation

#pragma mark - <ChainableOperationInput>

- (id)obtainInputData {
    return [self obtainBufferData];
}

- (id)obtainInputDataWithTypeValidationBlock:(ChainableOperationInputTypeValidationBlock _Nullable)block {
    if (block) {
        return [self obtainBufferDataWithValidationBlock:block];
    }
    
    return [self obtainBufferData];
}


#pragma mark - <ChainableOperationOutput>

- (void)didCompleteChainableOperationWithOutputData:(id _Nullable)outputData {
    [self updateBufferWithData:outputData];
}


#pragma mark - <CompoundOperationQueueInput>

- (void)setOperationQueueInputData:(id _Nonnull)inputData {
    [self updateBufferWithData:inputData];
}


#pragma mark - <CompoundOperationQueueOutput>

- (id)obtainOperationQueueOutputData {
    return [self obtainBufferData];
}


#pragma mark - Private Methods

- (void)updateBufferWithData:(id)data {
    self.buffer = data;
}

- (id)obtainBufferData {
    return self.buffer;
}

- (id)obtainBufferDataWithValidationBlock:(ChainableOperationInputTypeValidationBlock)block {
    id data = [self obtainBufferData];
    BOOL isBufferContentValid = block(data);
    if (!isBufferContentValid) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Buffer %@ data has incorrect format (%@)", self, NSStringFromClass([data class])];
    }
    return data;
}

@end
