### RxSwift学习记录- share vs replay vs shareReplay

#### 问题描述
多个订阅者导致Observable重复执行

```
let results: Observable<String> = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .map { "\($0)" }
    .flatMapLatest(convert)
    
func convert(str: String) -> Observable<String> {
    Observable<String>.create { observer in
        print("convert啊啊啊啊啊啊")
        observer.onNext("\(str)===convert")
        observer.onCompleted()
        return Disposables.create()
    }
}
```
下面三个订阅会使Observable创建三次，原本希望的是三个订阅者订阅同一次

```
let results = results.share()
results.subscribe(onNext: { str in
    print("第一个订阅者:\(str)")
}).disposed(by: disposeBag)
results.subscribe(onNext: { str in
    print("第二个订阅者:\(str)")
}).disposed(by: disposeBag)
results.subscribe(onNext: { str in
    print("第三个订阅者:\(str)")
}).disposed(by: self.disposeBag)

```
#### share
所有订阅者订阅后共用同一个Observable

```
let results = results.share()
results.subscribe(onNext: { str in
    print("第一个订阅者:\(str)")
}).disposed(by: disposeBag)
results.subscribe(onNext: { str in
    print("第二个订阅者:\(str)")
}).disposed(by: disposeBag)
delay(4) { 
    results.subscribe(onNext: { str in
        print("第三个订阅者:\(str)")
    }).disposed(by: self.disposeBag)
}
```
结果

```
convert啊啊啊啊啊啊
第一个订阅者:2===convert
第二个订阅者:2===convert
convert啊啊啊啊啊啊
第一个订阅者:3===convert
第二个订阅者:3===convert
convert啊啊啊啊啊啊
第一个订阅者:4===convert
第二个订阅者:4===convert
第三个订阅者:4===convert
```

#### publish
需手动`connect`，`connect`后开始发射值

```
let results = results.publish()
results.subscribe(onNext: { str in
    print("第一个订阅者:\(str)")
}).disposed(by: disposeBag)
results.subscribe(onNext: { str in
    print("第二个订阅者:\(str)")
}).disposed(by: disposeBag)
_ = results.connect()
delay(4) { 
    results.subscribe(onNext: { str in
        print("第三个订阅者:\(str)")
    }).disposed(by: self.disposeBag)
}
```

#### replayAll
后面订阅者会订阅后会收到所有之前的信号

#### shareReplay
共享Observable，且第一次订阅会重复播放对应数目信号

```
let results = results.share(replay: 2, scope: .forever)
results.subscribe(onNext: { str in
    print("第一个订阅者:\(str)")
}).disposed(by: disposeBag)
results.subscribe(onNext: { str in
    print("第二个订阅者:\(str)")
}).disposed(by: disposeBag)
delay(4) { 
    results.subscribe(onNext: { str in
        print("第三个订阅者:\(str)")
    }).disposed(by: self.disposeBag)
}
```

结果

````
convert啊啊啊啊啊啊
第一个订阅者:2===convert
第二个订阅者:2===convert
convert啊啊啊啊啊啊
第一个订阅者:3===convert
第二个订阅者:3===convert
第三个订阅者:2===convert
第三个订阅者:3===convert
````


