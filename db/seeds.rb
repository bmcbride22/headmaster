require 'faker'
puts 'Clearing DB'
Grade.delete_all
Average.destroy_all
SemesterCohort.destroy_all
SemesterCourse.destroy_all
Semester.destroy_all
Course.destroy_all
Cohort.destroy_all
User.destroy_all
StudentProfile.destroy_all
Subject.destroy_all
puts 'All records deleted'

teacher = User.create!(email: 'brendan@test.com', first_name: 'Brendan', last_name: 'McBride', password: 'password',
                       password_confirmation: 'password', role: 1)
#====================================================================================================
# Assessment types
#====================================================================================================

assessment_types = %w[Quiz Test Test Homework Project Classwork Lab Activity Essay]
assessment_types = { quiz: 'Quiz', test: 'Test', exam: 'Exam', homework: 'Homework', project: 'Project',
                     classwork: 'Classwork', lab: 'Lab', activity: 'Activity', essay: 'Essay' }
#====================================================================================================
# Subjects
#====================================================================================================
disciplines = ['Math', 'Science', 'English', 'Art', 'Economics', 'Social Studies']

disciplines.each do |subject|
  Subject.create(name: subject)
end

#====================================================================================================
# Dates
#====================================================================================================

fall_semester_start = Date.new(2021, 9, 1)
fall_semester_end = Date.new(2022, 1, 1)
winter_semester_start = Date.new(2022, 1, 2)
winter_semester_end	= Date.new(2023, 6, 30)

fall_sem_21 = Semester.create(title: 'Fall \'21', start_date: fall_semester_start, end_date: fall_semester_end)
winter_sem_22 = Semester.create(title: 'Winter \'22', start_date: winter_semester_start, end_date: winter_semester_end)
fall_sem_22 = Semester.create(title: 'Fall \'22', start_date: fall_semester_start + 1.year,
                              end_date: fall_semester_end + 1.year, current: true)

#====================================================================================================
# Cohorts
#====================================================================================================

cohort_1 = Cohort.create(name: '11-1', teacher:)
SemesterCohort.create(cohort: cohort_1, semester: fall_sem_21)
SemesterCohort.create(cohort: cohort_1, semester: winter_sem_22)

cohort_2 = Cohort.create(name: '11-2', teacher:)
SemesterCohort.create(cohort: cohort_2, semester: fall_sem_21)
SemesterCohort.create(cohort: cohort_2, semester: winter_sem_22)

cohort_3 = Cohort.create(name: '11-3', teacher:)
SemesterCohort.create(cohort: cohort_3, semester: fall_sem_21)
SemesterCohort.create(cohort: cohort_3, semester: winter_sem_22)

cohorts = [cohort_1, cohort_2, cohort_3]

cohorts.each do |cohort|
  25.times do
    student = StudentProfile.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
    Enrollment.create(student:, cohort:)
  end
end

#====================================================================================================
# Syllabus and Units
#====================================================================================================

econ = Subject.find_by(name: 'Economics')
econ_11 = Syllabus.create(title: 'QCE 11 Econ', subject: econ, teacher:)
unit_1 = Unit.create(title: 'Markets and Models', weight: 0.5, syllabus: econ_11)
unit_2 = Unit.create(title: 'Modified Markets', weight: 0.5, syllabus: econ_11)

topic_1_1 = Unit.create(title: 'The Basic Economic Problem', weight: 0.25, parent_unit: unit_1, syllabus: econ_11,
                        main_unit: false)
topic_1_2 = Unit.create(title: 'Economic Flows', weight: 0.25, parent_unit: unit_1, syllabus: econ_11,
                        main_unit: false)
topic_1_3 = Unit.create(title: 'Market Forces', weight: 0.25, parent_unit: unit_1, syllabus: econ_11,
                        main_unit: false)
unit_1_final_exam = Unit.create(title: 'Unit 1 Final Exam', weight: 0.25, parent_unit: unit_1, syllabus: econ_11,
                                main_unit: false)

unit_1_topics = [topic_1_1, topic_1_2, topic_1_3]

topic_2_1 = Unit.create(title: 'Markets and Efficiency', weight: 0.375, parent_unit: unit_2, syllabus: econ_11,
                        main_unit: false)
topic_2_2 = Unit.create(title: 'Environmental Economics', weight: 0.375, parent_unit: unit_2, syllabus: econ_11,
                        main_unit: false)
unit_2_final_exam = Unit.create(title: 'Unit 2 Final Exam', weight: 0.25, parent_unit: unit_2, syllabus: econ_11,
                                main_unit: false)

unit_2_topics = [topic_2_1, topic_2_2]

cohorts.each do |cohort|
  course = Course.create(cohort:, syllabus: econ_11,
                         title: "QCE Econ #{cohort.name}", description: "This is the course for #{econ_11.title} for #{cohort.name}", teacher:)
  SemesterCourse.create(course:, semester: fall_sem_21)
  SemesterCourse.create(course:, semester: winter_sem_22)
end

def assessment_weight(assessment_type)
  case assessment_type
  when 'Quiz'
    0.15
  when 'Test'
    0.35
  when 'Project'
    0.35
  when 'Exam'
    0.25
  when 'Essay'
    0.35
  end
end
#====================================================================================================
# Topic 1.1 Assessments
#====================================================================================================

factors_production_income_quiz = Assessment.create(title: 'Factors of Production and Income Quiz',
                                                   description: 'This quiz will test students understanding of the factors of production and how they are linked to income',
                                                   assessment_type: 'Quiz',
                                                   teacher:,
                                                   subject: econ, unit: topic_1_1, weight: assessment_weight('Quiz'))
opportunity_cost_quiz = Assessment.create(title: 'Opportunity Cost Quiz',
                                          description: 'This quiz will assess students understanding of the concept of opportunity cost and its significance in decision-making, where benefits are subjectively measured against costs.',
                                          assessment_type: 'Quiz',
                                          teacher:,
                                          subject: econ, unit: topic_1_1, weight: assessment_weight('Quiz'))

economic_systems_project = Assessment.create(title: 'Analyzing Economic Systems Project',
                                             description: 'A project that requires students to analyze how different economic systems attempt to resolve the three economic questions using real-world testples',
                                             assessment_type: 'Project',
                                             teacher:,
                                             subject: econ, unit: topic_1_1, weight: assessment_weight('Project'))

economic_fundamentals_test = Assessment.create(title: 'Economic Fundamentals Test',
                                               description: 'An test that covers all the fundamental concepts of economics including the basic economic problem, factors of production, income, production possibility curve, and different economic systems',
                                               assessment_type: 'Test',
                                               teacher:,
                                               subject: econ, unit: topic_1_1, weight: assessment_weight('Test'))

topic_1_1_assessments = [factors_production_income_quiz, opportunity_cost_quiz,
                         economic_systems_project, economic_fundamentals_test]

#====================================================================================================
# Topic 1.2  Assessments
#====================================================================================================

circular_flow_income_quiz = Assessment.create(title: 'The Circular Flow of Income Model Quiz',
                                              description: 'Used to assess the students understanding of construction and significance of the five-sector circular flow of income model, including the relationships between the sectors, injections and withdrawals, and equilibrium conditions.',
                                              assessment_type: 'Quiz',
                                              teacher:,
                                              subject: econ, unit: topic_1_2, weight: assessment_weight('Quiz'))

government_economic_flows_quiz = Assessment.create(title: 'Government Decisions and Economic Flows Quiz',
                                                   description: 'Used to assess the students understanding of how government spending and taxation impact the economy using aggregate demand and the circular flow of income model, and how changes in the cash rate by the Reserve Bank of Australia affect aggregate demand and the circular flow of income.',
                                                   assessment_type: 'Quiz',
                                                   teacher:,
                                                   subject: econ, unit: topic_1_2, weight: assessment_weight('Quiz'))

economic_flows_test =  Assessment.create(title: 'Economic Flows Test',
                                         description: 'An test that covers all the concepts of economic flows including the circular flow of income model, government decisions, aggregate demand and supply and effects of various factors on the economy',
                                         assessment_type: 'Test',
                                         teacher:,
                                         subject: econ, unit: topic_1_2, weight: assessment_weight('Test'))

economic_flows_project = Assessment.create(title: 'Analyzing Economic Flows in Real World',
                                           description: 'A project that requires students to analyze current and topical economic events and their impact on various economic flows, and draw conclusions or make decisions based on the analysis',
                                           assessment_type: 'Project',
                                           teacher:,
                                           subject: econ, unit: topic_1_2, weight: assessment_weight('Project'))

topic_1_2_assessments = [circular_flow_income_quiz,
                         government_economic_flows_quiz, economic_flows_test, economic_flows_project]

#====================================================================================================
# Topic 1.3 assessments
#====================================================================================================

equilibrium_elasticity_quiz =  Assessment.create(title: 'Equilibrium and Elasticity Quiz',
                                                 description: 'This quiz will test students understanding of market equilibrium and the concept of elasticity of demand and supply.',
                                                 assessment_type: 'Quiz',
                                                 teacher:,
                                                 subject: econ, unit: topic_1_3, weight: assessment_weight('Quiz'))

market_characteristics_quiz =  Assessment.create(title: 'Market Characteristics Quiz',
                                                 description: 'This quiz will test students understanding of the different characteristics of goods and services, including private, public, merit, substitute and complementary',
                                                 assessment_type: 'Quiz',
                                                 teacher:,
                                                 subject: econ, unit: topic_1_3, weight: assessment_weight('Quiz'))

market_supply_shock_essay = Assessment.create(title: 'Market Forces and Supply Shocks Essay',
                                              description: 'This essay will require students to analyze the effects of a supply shock on market forces, including changes in prices and quantities, and the potential implications for both consumers and producers.',
                                              assessment_type: 'Essay',
                                              teacher:,
                                              subject: econ, unit: topic_1_3, weight: assessment_weight('Essay'))

market_forces_test =  Assessment.create(title: 'Market Forces Test',
                                        description: 'This test will test students understanding of the key concepts and subject matter covered in Topic 3 including market forces, market equilibrium, elasticity of demand and supply, and the characteristics of goods and services.',
                                        assessment_type: 'Test',
                                        teacher:,
                                        subject: econ, unit: topic_1_3, weight: assessment_weight('Test'))

topic_1_3_assessments = [equilibrium_elasticity_quiz, market_characteristics_quiz,
                         market_supply_shock_essay, market_forces_test]

#====================================================================================================
# Final exam assessment
#====================================================================================================
markets_and_models_exam = Assessment.create(title: 'Markets and Models Exam',
                                            description: 'This final exam will test students understanding of key economic concepts from Topic 1, Topic 2 and Topic 3, including scarcity, choices, economic flows, market forces, and elasticity of demand and supply.',
                                            assessment_type: 'Exam',
                                            teacher:,
                                            subject: econ, unit: unit_1_final_exam, weight: assessment_weight('Exam'))

#====================================================================================================
# Final Exam Assessment
#====================================================================================================

unit_1_assessments = topic_1_1_assessments + topic_1_2_assessments + topic_1_3_assessments + [markets_and_models_exam]

#====================================================================================================
# Unit 2
#====================================================================================================

#====================================================================================================
# Unit 2.1 assessments
#====================================================================================================

market_failure_quiz = Assessment.create(title: 'Market Failure Quiz',
                                        description: 'This quiz will test students understanding of the causes and effects of market failure, including excesses of boom and bust cycles, externalities, market power, public goods, and asymmetric information.',
                                        assessment_type: 'Quiz',
                                        teacher:,
                                        subject: econ, unit: topic_2_1, weight: assessment_weight('Quiz'))

market_modification_quiz = Assessment.create(title: 'Market Modification Quiz',
                                             description: 'This quiz will test students understanding of different methods of market modification required to correct market failure, including direct and indirect taxation, subsidies, price floors/ceilings, and regulation.',
                                             assessment_type: 'Quiz',
                                             teacher:,
                                             subject: econ, unit: topic_2_1, weight: assessment_weight('Quiz'))

market_failure_research_project = Assessment.create(title: 'Market Failure Research Project',
                                                    description: 'This project will require students to conduct research on a specific market failure and analyze the causes and effects of the market failure, as well as potential methods of correction.',
                                                    assessment_type: 'Project',
                                                    teacher:,
                                                    subject: econ, unit: topic_2_1, weight: assessment_weight('Project'))

markets_efficiency_test = Assessment.create(title: 'Markets and Efficiency Test',
                                            description: 'This exam will cover the material from Topic 1: Markets and Efficiency, including key concepts such as allocative efficiency, market failure, and methods of correction.',
                                            assessment_type: 'Test',
                                            teacher:,
                                            subject: econ, unit: topic_2_1, weight: assessment_weight('Test'))

topic_2_1_assessments = [market_failure_quiz, market_modification_quiz,
                         market_failure_research_project, markets_efficiency_test]

#====================================================================================================
# Unit 2.2  Assessments
#====================================================================================================

environmental_impacts_quiz =  Assessment.create(title: 'Environmental Impacts of Economic Activities Quiz',
                                                description: 'This quiz will assess the students understanding of the environmental impacts of economic activities and the trade-offs between economic growth and ecologically sustainable development.',
                                                assessment_type: 'Quiz',
                                                teacher:,
                                                subject: econ, unit: topic_2_2, weight: assessment_weight('Quiz'))

valuing_externalities_quiz =  Assessment.create(title: 'Valuing Externalities Quiz',
                                                description: 'This quiz will assess the students understanding of the challenge of valuing externalities and ensuring they are reflected in market prices.',
                                                assessment_type: 'Quiz',
                                                teacher:,
                                                subject: econ, unit: topic_2_2, weight: assessment_weight('Quiz'))

government_strategies_project =  Assessment.create(title: 'Government Strategies for Redressing Environmental Degradation Project',
                                                   description: 'This project will require students to research and analyze government strategies and/or interventions to redress environmental degradation and significant measures to achieve economic and ecological sustainability.',
                                                   assessment_type: 'Project',
                                                   teacher:,
                                                   subject: econ, unit: topic_2_2, weight: assessment_weight('Project'))

environmental_economics_essay =  Assessment.create(title: 'Environmental Economics Essay',
                                                   description: 'In this essay, students will analyze and evaluate the trade-off between economic growth and ecologically sustainable development, using data and economic information from sources such as the environmental performance index and the environmental Kuznets curve. They will also examine government strategies and interventions to address environmental degradation and determine socially optimal levels of production and consumption.',
                                                   assessment_type: 'Essay',
                                                   teacher:,
                                                   subject: econ, unit: topic_2_2, weight: assessment_weight('Essay'))
topic_2_2_assessments = [environmental_impacts_quiz,
                         valuing_externalities_quiz, government_strategies_project, environmental_economics_essay]

#====================================================================================================
# Unit 2 Final Exam
#====================================================================================================

market_efficiency_and_environmental_economics_exam = Assessment.create(title: 'Market Efficiency and Environmental Economics Exam',
                                                                       description: 'This exam will test students on their understanding of market forces and efficiency, as well as their knowledge of the environmental impacts of economic activities and strategies for achieving economic and ecological sustainability.',
                                                                       assessment_type: 'Exam',
                                                                       teacher:,
                                                                       subject: econ, unit: unit_2_final_exam, weight: assessment_weight('Exam'))

unit_2_assessments = topic_2_1_assessments + topic_2_2_assessments + [market_efficiency_and_environmental_economics_exam]

courses = Course.all

courses.each_with_index do |course, _i|
  ass_count = 0
  course.cohort.students.each do |student|
    ass_date = Date.new(2021, 9, 1)
    ranges = [1, 2, 2, 3, 3, 4]
    range = ranges.sample
    mean = case range
           when 1
             rand(0.85..0.94)
           when 2
             rand(0.72..0.85)
           when 3
             rand(0.54..0.7)
           else
             rand(0.48..0.56)

           end
    sd = rand(0.04..0.06)
    gen = Rubystats::NormalDistribution.new(mean, sd)
    course.syllabus.main_units.each do |unit|
      unit.sections.each do |section|
        section.assessments.each_with_index do |assessment, i|
          ass_difficulty_modifier = rand(-0.06..0.06)
          ass_count += 1
          ass_date += 9.days
          score = gen.rng + ass_difficulty_modifier + (i * 0.004)

          score = 1.0 - rand(0.05) if score > 1.0
          puts ass_count
          puts score
          puts ass_date
          Grade.create(student:, assessment:, course:, score: (score * 100).round(2), date: ass_date)
        end
      end
    end
  end
end
