// ProtocolのGenericsの出来ることと出来ないことのTIps

protocol BaseEntity: class {
    
    associatedtype IdentityType
    
    var identity: IdentityType { get }
}

class RateEntity: BaseEntity {
    
    typealias IdentityType = Int
    
    var identity: IdentityType = 0
}

class OrderEntity: BaseEntity {
    
    typealias IdentityType = String
    
    var identity: IdentityType = "0"
}

class PositionEntity: BaseEntity {
    
    typealias IdentityType = String
    
    var identity: IdentityType = "1"
}


// associatedtypeで実装側がGenericsの型を決める
// この場合、associatedtypeの同じものは配列に入れることはできる

let rate1 = RateEntity()
let rate2 = RateEntity()

let order1 = OrderEntity()
let order2 = OrderEntity()

let position1 = OrderEntity()
let position2 = OrderEntity()

// Genericsの型が同じなので、OK
let intArray = [rate1, rate2]
print(intArray[0].identity)
print(intArray[1].identity)

// ここで下記のような配列にprotocol(generics指定)の配列宣言はコンパイルエラーになる
// error: protocol 'BaseEntity' can only be used as a generic constraint because it has Self or associated type requirements
//let intArray2: Array<BaseEntity>



// クラスの型は違うが、Genericsの型は一緒なのでOK
let strArray = [order1, position1]
print(strArray[0].identity)
print(strArray[1].identity)

// 下記はエラー
//  error: heterogenous collection literal could only be inferred to '[Any]'; add explicit type annotation if this is intentional
//let strArray2 = [rate1, order1, position1]
//print(setArray2[0].identity)

// 下記のようにAny型にするとコンパイルは通るが、BaseEntityの
// メソッドであるidentityは呼べない(downcastしたら可能)
let etcArray: [Any] = [rate1, order1, position1]
//print(etcArray[0].identity)

// genericsのprotocolはdowncast出来ないので実装クラスの型でdowncast
for etc in etcArray {
    if etc is RateEntity {
        print("RateEntity")
        print((etc as! RateEntity).identity)
    } else if etc is PositionEntity {
        print("PositionEntity")
        print((etc as! PositionEntity).identity)
    } else if etc is OrderEntity {
        print("OrderEntity")
        print((etc as! OrderEntity).identity)
    }
}

// なんとなく、配列はprotocolを実装しているクラスであれば、同じ型なので
// 使用できそうな気もしますが、現段階ではコンパイルエラーになる
// 今後のswfitのバージョンアップで対応される可能性あり
// 参考：https://speakerdeck.com/ishkawa/json-rpc-on-apikit
// 現在は配列や可変引数で渡せないので、swiftの書き方に準拠して、
// 引数を1、2、3など別々に作成して対応しているっぽい

// Genericsでなければ当然のように、配列に入れるのはOK
protocol BaseModel: class {
    
    var identity: String { get }
}

class RateModel: BaseModel {
    
    var identity: String = "0"
}

class OrderModel: BaseModel {
    
    var identity: String = "1"
}

class PositionModel: BaseModel {
    
    var identity: String = "2"
}

let rateModel = RateModel()
let orderModel = OrderModel()
let positionModel = PositionModel()

let modelArray: Array<BaseModel> = [rateModel, orderModel, positionModel]
print(modelArray[0].identity)
print(modelArray[1].identity)
print(modelArray[2].identity)

print ("Done!")

