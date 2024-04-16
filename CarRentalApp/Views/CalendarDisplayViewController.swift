//
//  CalendarDisplayViewController.swift
//  CarRentalApp
//
//  Created by Omar Hegazy on 4/14/24.
//

import UIKit
import HorizonCalendar
import SwiftUI

final class CalendarDisplayViewController: UIViewController {
    
    private func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: DateComponents(year: 2024, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2024, month: 12, day: 31))!
        
        let lowerDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 20))!
        let upperDate = calendar.date(from: DateComponents(year: 2020, month: 02, day: 07))!
        let dateRangeToHighlight = lowerDate...upperDate
        
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))
        .dayItemProvider { day in
            DayLabel.calendarItemModel(
                invariantViewProperties: .init(
                    font: UIFont.systemFont(ofSize: 18),
                    textColor: .darkGray,
                    backgroundColor: .clear),
                content: .init(day: day))
        }
        
        .dayRangeItemProvider(for: [dateRangeToHighlight], { dayRangeLayoutContext in
            <#code#>
        })
        
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarView = CalendarView(initialContent: makeContent())
        
        view.addSubview(calendarView)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
}

struct DayLabel: CalendarItemViewRepresentable {
    
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        let font: UIFont
        let textColor: UIColor
        let backgroundColor: UIColor
    }
    
    /// Properties that will vary depending on the particular date being displayed.
    struct Content: Equatable {
        let day: DayComponents
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel
    {
        let label = UILabel()
        
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        
        return label
    }
    
    static func setContent(_ content: Content, on view: UILabel) {
        view.text = "\(content.day.day)"
    }
    
}

final class DayRangeIndicatorView: UIView {

  private let indicatorColor: UIColor

  init(indicatorColor: UIColor) {
    self.indicatorColor = indicatorColor
    super.init(frame: frame)
    backgroundColor = .clear
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  var framesOfDaysToHighlight = [CGRect]() {
    didSet {
      guard framesOfDaysToHighlight != oldValue else { return }
      setNeedsDisplay()
    }
  }

  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(indicatorColor.cgColor)

    // Get frames of day rows in the range
    var dayRowFrames = [CGRect]()
    var currentDayRowMinY: CGFloat?
    for dayFrame in framesOfDaysToHighlight {
      if dayFrame.minY != currentDayRowMinY {
        currentDayRowMinY = dayFrame.minY
        dayRowFrames.append(dayFrame)
      } else {
        let lastIndex = dayRowFrames.count - 1
        dayRowFrames[lastIndex] = dayRowFrames[lastIndex].union(dayFrame)
      }
    }

    // Draw rounded rectangles for each day row
    for dayRowFrame in dayRowFrames {
      let roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, cornerRadius: 12)
      context?.addPath(roundedRectanglePath.cgPath)
      context?.fillPath()
    }
  }

}

extension DayRangeIndicatorView: CalendarItemViewRepresentable {

  struct InvariantViewProperties: Hashable {
    let indicatorColor = UIColor.blue.withAlphaComponent(0.15)
  }

  struct Content: Equatable {
    let framesOfDaysToHighlight: [CGRect]
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> DayRangeIndicatorView
  {
    DayRangeIndicatorView(indicatorColor: invariantViewProperties.indicatorColor)
  }

  static func setContent(_ content: Content, on view: DayRangeIndicatorView) {
    view.framesOfDaysToHighlight = content.framesOfDaysToHighlight
  }

}

struct CalendarViewWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let viewController = CalendarDisplayViewController()
        return viewController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
