class DashboardsController < ApplicationController
  before_action :authenticate_user!
  layout 'application'

  def main
    @cohorts = current_user.classes
    @averages = Average.includes(:unit, { course: :cohort }).where(course_id: current_user.courses, course_avg: true)
    course_avgs_by_date = @averages.group(:course_id, :date).average(:average)
                                   .each_with_object({}) do |((course_id, date), average_average), m|
      m[course_id] ||= {}
      m[course_id][date] = average_average
    end
    colors = ['#4c1d95', '#8b5cf6', '#c4b5fd', '#6d28d9', '#ede9fe']
    data_sets = []
    course_avgs_by_date.each do |course_id, avgs_by_date|
      color = colors.shift
      data_sets << {
        label: Course.find(course_id).title,
        data: avgs_by_date.values.map { |avg| (avg * 100).round(2) },
        backgroundColor: color,
        lineColor: color,
        borderColor: color,
        pointStyle: 'circle',
        pointRadius: 3
      }
    end
    @chart_data = {
      labels: course_avgs_by_date.first[1].keys.map { |date| date.strftime('%-d %b, %Y') },
      datasets: data_sets
    }.to_json
  end
end
