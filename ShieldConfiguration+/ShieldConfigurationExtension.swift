//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration+
//
//  Created by 三浦一真 on 2024/08/11.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

//// Override the functions below to customize the shields used in various situations.
//// The system provides a default appearance for any methods that your subclass doesn't override.
//// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
//class ShieldConfigurationExtension: ShieldConfigurationDataSource {
//    override func configuration(shielding application: Application) -> ShieldConfiguration {
//        // Customize the shield as needed for applications.
//        ShieldConfiguration()
//    }
//    
//    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
//        // Customize the shield as needed for applications shielded because of their category.
//        ShieldConfiguration()
//    }
//    
//    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
//        // Customize the shield as needed for web domains.
//        ShieldConfiguration()
//    }
//    
//    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
//        // Customize the shield as needed for web domains shielded because of their category.
//        ShieldConfiguration()
//    }
//}

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.dark,
            backgroundColor: UIColor.black,
            icon: UIImage(named: "AppIcon"),
            title: ShieldConfiguration.Label(
                text: "アプリ制限中",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "全ては目標達成のためです。",
                color: .white
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "とじる",
                color: .black
            ),
            primaryButtonBackgroundColor: .yellow
        )
    }
}
