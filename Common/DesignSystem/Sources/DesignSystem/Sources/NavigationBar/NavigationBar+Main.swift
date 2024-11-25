//
//  File.swift
//  
//
//  Created by 고영민 on 11/22/24.
//

import UIKit
import SnapKit

public final class WIMainNavigationBar: UIView {
    
    public var alarmButtonClosure: (() -> Void)?
    public var alarmStatus: AlarmStatus = .defaultAlarm {
        didSet {
            alarmButton.setImage(alarmStatus.icon, for: .normal)
        }
    }
    
    private let alarmButton = UIButton()
    private var bottomSeparatorView = UIView()
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: WINavigationBar.Const.navigationBarHeight)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .buttwink_gray0
        bottomSeparatorView.backgroundColor = .buttwink_gray200
        
        alarmButton.setImage(.Icon.alarm_default, for: .normal)
        alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
    }
    
    private func setLayout() {
        addSubview(alarmButton)
        addSubview(bottomSeparatorView)

   
        alarmButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.size.equalTo(48)
        }
        
        bottomSeparatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @objc
    private func alarmButtonTapped() {
        self.alarmButtonClosure?()
    }
}

extension WIMainNavigationBar {
    public enum AlarmStatus: CaseIterable {
        case defaultAlarm
        case newAlarm
        
        var icon: UIImage? {
            switch self {
            case .defaultAlarm:
                return .Icon.alarm_default
            case .newAlarm:
                return .Icon.alarm_variant
            }
        }
    }
}
