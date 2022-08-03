# arbiter-ios-sdk
arbiter의 iOS SDK 프로젝트

## 0. 기본 요건

프로젝트가 다음 요구사항을 충족하는지 확인합니다.

- 타겟 iOS 버전 11.0 이상

<br>

## 1. SDK 연동

알비테르를 사용하려는 개발 코드에 SDK를 연동한 적이 없다면 SDK를 우선 연동해야 합니다.
SDK 연동은 최초 1회만 진행합니다. 이미 연동했다면 바로 다음단계로 이동할 수 있습니다.

KEP SDK 기능을 사용하기 위해서는 반드시 SDK 연동 작업이 필요합니다.

다음과 같은 방식으로 제공합니다.

- SPM (Swift Package Manager)
- Cocoapods (지원 예정)

#### Swift Pacakage Manager를 통해 의존성을 추가하는 방법

Xcode > File > Add Packages... 를 선택한 뒤 현재 github repository를 package에 추가합니다.

#### Cocoapods 을 통해 의존성을 추가하는 방법 (지원 예정)

🚧 현재 Cocoapods를 통한 의존성 추가를 지원하고있지 않습니다. 추후 지원 예정입니다.

### SDK 초기화

```swift
import Arbiter
let Arbiter = KepArbiter()

Arbiter.initialize("aWQ9MCZ0ZW5hbnQ9S0FLQU8=")
```

알비테르 의존성을 추가한 뒤 arbiter instance를 생성합니다. 이후 모든 알비테르 동작은 해당 인스턴스를 통해 이루어집니다.

앱의 진입점 (AppDelegate 혹은 App.init) 에 `initialize(_ sdkKey)` 메소드를 호출하여 알비테르 인스턴스를 초기화합니다. sdkKey는 카카오엔터프라이즈를 통해 발급받으신 key를 입력해주세요.

### TIP: 앱 로딩화면을 통해 알비테르를 초기화하기

앱의 로딩화면 (launchScreen) 을 통해 알비테르를 초기화 할 수 있습니다. 알비테르 초기화 메소드의 완료 콜백을 통해 로딩화면을 닫고 메인 페이지를 로드하여 알비테르가 초기화된 상태로 앱을 시작할 수 있습니다.

초기화 이후 생성한 알비테르 인스턴스를 통해 알비테르를 실행할 수 있습니다.

```swift
// launchScreen 로드
Arbiter.initialize("aWQ9MCZ0ZW5hbnQ9S0FLQU8=") {
  // 앱 초기 화면 로드
}
```

<br>

## 2. SDK 기능

### 1. 테스트 그룹 분배

테스트 그룹은 테스트 대상이 되는 **기존안(대조군)**과 **개선안(실험군)**을 의미합니다.

**개선안**은 1개 이상일 수 있습니다.

대시보드에서 설정 가능하며, 테스트 그룹을 관리하는 방법에 대해서는 추후 자성될 ‘A/B  테스트 설정' 문서를 참고하시기 바랍니다.

### 실험 token

실험 token 을 통하여 A/B Test 를 진행할 수 있습니다.

### ****variation****


위의 **실험 token** 를 요청하여 받은 결과가 **variation** 입니다.

ex) `단순 text` , `Json 형태의 결과물` 등을 반환 받을 수 있습니다.

### Variation 응답 형태

1. `Constant` Type일 경우

   응답값은 text, json 형태로 받을 수 있습니다.

   응답값(ex) red or blue)은 알비테르 DB에 저장


2. `ByPass` Type 일 경우

    일반적으로 로직, 알고리즘 실험의 경우 variation 설정시, `ByPass` 라는 기능을 이용하여 설정하게 됩니다.

    `ByPass` 기능을 이용할 경우, `요청 URL` 로 요청시에 알고리즘 V1 서버, 알고리즘 V2 서버로 부터 응답받은 결과를 받게됩니다.


<br>

# 분배 형태

분배 형태의 경우 크게 2가지로 나눌 수 있습니다.

1. 단순 UI 실험
2. 로직, 알고리즘 실험

**공통사항**

위에 있는 `실험 token`  옆에 있는 클립보드 버튼을 눌러 `variation` 함수에 인자로 넣습니다.

### 1. 단순 UI 실험(Constant)

ex) 배너 이미지 테스트, 단순 색깔 변경

```swift
let response: String = Arbiter.variation(token: "zlWoqwPDuf") ?? "default"

var color: UIColor = .black
switch response {
	case "red":
		color = .red
	case "blue":
		color = .blue
	default:
		break
}
DispatchQueue.main.async { [weak self] in
	self?.bannerView.backgroundColor = color
}
```

### 2. 로직, 알고리즘 실험 (Bypass)

ex) 추천 알고리즘 실험

```swift
import UIKit
import Arbiter

struct item: Decodable {
    let name: String
    let color: String
    let price: Int
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var items: [item] = [] // 결과를 담을 변수를 설정
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Atbiter fetch 후 결과값 디코딩하고 뷰를 그림
				items = Arbiter.variation(token: "bnuwxzoQQU")
        DispatchQueue.main.async {
            self?.tableView.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        var background = UIBackgroundConfiguration.listPlainCell()
        
        // Arbiter fetch의 결과값으로 cell을 구성
        content.text = items[indexPath.row].name
        content.secondaryText = "\(items[indexPath.row].price)원"
        background.backgroundColor = UIColor(hexString: items[indexPath.row].color)
        //
        
        background.cornerRadius = 15
        background.backgroundInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        cell.contentConfiguration = content
        cell.backgroundConfiguration = background
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

// String Hex 값으로 색상을 반환하는 편의상 사용하는 함수
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
```


### 2. 사용자 이벤트 전송

SDK는 사용자 이벤트를 알비테르로 전송하는 기능을 제공합니다.

사용자 행동의 변화가 일어나는 지점마다 이 기능을 활용하면 사용자 행동에 대한 유의미한 데이터를 얻을 수 있으며, 그렇게 모인 데이터를 통해 사용자 행동 분석을 할 수 있습니다.

`logEvent()`메소드에 **이벤트 키**를 전달하여 사용자 이벤트를 전송할 수 있습니다.

`Property` 값을 담아서 `key-value` 형태로 전송합니다.

```swift
KepArbiter.logEvent("purchase", parameters: [String: Any])
```

`Property` 는 생략이 가능합니다.

```swift
KepArbiter.logEvent("purchase")
```

<br><br>

알비테르 iOS 가이드 관련 추가 정보를 확인하고 싶으시다면 https://dpt.notion.site/Arbiter-SDK-iOS-c0b12b5a27c4402c9da8f238cd554e66 를 확인해주세요.
