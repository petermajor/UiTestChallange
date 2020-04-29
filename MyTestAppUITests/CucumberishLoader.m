#import <Foundation/Foundation.h>
#import "MyTestAppUITests-Swift.h"

__attribute__((constructor))
void CucumberishInit(){
    [CucumberishInitializer setupCucumberish];
}
