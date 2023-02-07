class DashboardsController < ApplicationController
  before_action :authenticate_user!
  layout 'application'

  def main
    @cohorts = Cohort.where(teacher: current_user)
    @semesters = current_user.semesters.order(:id).uniq
    @averages = Average.includes(:unit, { course: :cohort }).where(course_id: current_user.courses, course_avg: true)
    @semester_avgs = {}
    @dropdown_semesters = @semesters.map { |semester| { id: semester.id, title: semester.title } }
    @semesters.each do |semester|
      semester_avg = @averages.where('date >= ? AND date <= ?', semester.start_date,
                                     semester.end_date).group(:course_id, :date).order(:date).average(:average).each_with_object({}) do |((course_id, date), average_average), m|
        m[course_id] ||= {}
        m[course_id][date] = average_average
      end
      @semester_avgs[semester.id] = semester_avg
    end

    @course_avgs_by_date = @averages.group(:course_id, :date).order(:date).average(:average)
                                    .each_with_object({}) do |((course_id, date), average_average), m|
      m[course_id] ||= {}
      m[course_id][date] = average_average
    end

    data_sets = []
    if @course_avgs_by_date.empty?
      @chart_data = {}
    else
      @chart_data = {}
      @semester_avgs.each do |semester_id, semester_avgs|
        colors = ['#4c1d95', '#8b5cf6', '#c4b5fd', '#6d28d9', '#ede9fe']
        labels = []
        data_sets = []
        semester_avgs.each do |course_id, avgs_by_date|
          color = colors.shift
          data_sets << {
            label: Course.find(course_id).title,
            data: avgs_by_date.values.map { |avg| avg.round(1) },
            backgroundColor: color,
            lineColor: color,
            borderColor: color,
            pointStyle: 'circle',
            pointRadius: 4
          }
          labels << avgs_by_date.keys.map { |date| date.strftime('%-d %b, %Y') }
        end
        @chart_data[semester_id] = {
          labels: labels.flatten.uniq,
          datasets: data_sets
        }
      end
      @chart_data = @chart_data.to_json

      group_1 = Average.where('course_avg = true AND average >= 85 AND current = true').count
      group_2 = Average.where('course_avg = true AND average < 85 AND average >= 70 AND current = true').count
      group_3 = Average.where('course_avg = true AND average < 70 AND average >= 55 AND current = true').count
      group_4 = Average.where('course_avg = true AND average < 55 AND current = true').count

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
end
