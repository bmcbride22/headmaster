class DashboardsController < ApplicationController
  before_action :authenticate_user!
  layout 'application'

  def main
    @cohorts = current_user.classes
    @averages = Average.includes(:unit, { course: :cohort }).where(course_id: current_user.courses, course_avg: true)
    course_avgs_by_date = @averages.group(:course_id, :date).order(:date).average(:average)
                                   .each_with_object({}) do |((course_id, date), average_average), m|
      m[course_id] ||= {}
      m[course_id][date] = average_average
    end
    colors = ['#4c1d95', '#8b5cf6', '#c4b5fd', '#6d28d9', '#ede9fe']
    data_sets = []
    if course_avgs_by_date.empty?
      @chart_data = {}
    else
      course_avgs_by_date.each do |course_id, avgs_by_date|
        color = colors.shift
        data_sets << {
          label: Course.find(course_id).title,
          data: avgs_by_date.values.map { |avg| (avg * 100).round(2) },
          backgroundColor: color,
          lineColor: color,
          borderColor: color,
          pointStyle: 'circle',
          pointRadius: 4
        }
      end
      @chart_data = {
        labels: course_avgs_by_date.first[1].keys.map { |date| date.strftime('%-d %b, %Y') },
        datasets: data_sets
      }.to_json
    end

    group_1 = Average.where('course_avg = true AND average >= 0.85 AND current = true').count
    group_2 = Average.where('course_avg = true AND average < 0.85 AND average >= 0.7 AND current = true').count
    group_3 = Average.where('course_avg = true AND average < 0.7 AND average >= 0.55 AND current = true').count
    group_4 = Average.where('course_avg = true AND average < 0.55 AND current = true').count

    group_data = [group_1, group_2, group_3, group_4]

    @achievement_groups =
      {
        labels: ['+85', '70-85', '55-70', ' 0-55'],
        datasets: [{ backgroundColor: ['#5b21b6', '#7c3aed', '#a78bfa', '#ddd6fe'],
                     label: 'Students',
                     data: group_data }]
      }.to_json
  end
end
