require 'faker'

teacher = User.create(email: 'brendan@test.com', first_name: 'Brendan', last_name: 'McBride', password: 'password',
                      password_confirmation: 'password', role: 1)
#====================================================================================================
# Assessment types
#====================================================================================================

assessment_types = %w[Quiz Test Test Homework Project Classwork Lab Activity Essay]
instrument_types = { quiz: 'Quiz', test: 'Test', exam: 'Exam', homework: 'Homework', project: 'Project',
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

fall_semester_start = Date.new(2022, 9, 1)
fall_semester_end = Date.new(2022, 12, 14)
winter_semester_start = Date.new(2022, 12, 15)
winter_semester_end	= Date.new(2023, 6, 30)

#====================================================================================================
# Cohorts
#====================================================================================================

cohort_1 = Cohort.create(name: 'QCE 11-1', start_date: winter_semester_start, end_date: fall_semester_end)
cohort_2 = Cohort.create(name: 'QCE 11-2', start_date: winter_semester_start, end_date: fall_semester_end)
cohort_3 = Cohort.create(name: 'QCE 11-3', start_date: winter_semester_start, end_date: fall_semester_end)

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
econ_11 = Syllabus.create(title: 'QCE 11 Economics', subject: econ, teacher:)
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
  Course.create(cohort:, syllabus: econ_11, start_date: winter_semester_start, end_date: fall_semester_end,
                title: "#{econ_11.title} - #{cohort.name}", description: "This is the course for #{econ_11.title} for #{cohort.name}")
end

#====================================================================================================
# Topic 1.1 instruments
#====================================================================================================

basic_economic_problem_quiz = Instrument.create(title: 'The Basic Economic Problem Quiz',
                                                description: 'This quiz will test students understanding of the basic economic problem of scarcity and how it causes individuals, businesses and governments to make choices',
                                                instrument_type: 'Quiz',
                                                creator: teacher,
                                                subject: econ)

factors_production_income_quiz = Instrument.create(title: 'Factors of Production and Income Quiz',
                                                   description: 'This quiz will test students understanding of the factors of production and how they are linked to income',
                                                   instrument_type: 'Quiz',
                                                   creator: teacher,
                                                   subject: econ)
opportunity_cost_quiz = Instrument.create(title: 'Opportunity Cost Quiz',
                                          description: 'This quiz will assess students understanding of the concept of opportunity cost and its significance in decision-making, where benefits are subjectively measured against costs.',
                                          instrument_type: 'Quiz',
                                          creator: teacher,
                                          subject: econ)

production_possibility_curve_quiz = Instrument.create(title: 'Production Possibility Curve Quiz',
                                                      description: 'This quiz will test students understanding of the production possibility curve and its use in illustrating concepts of scarcity, choice, opportunity cost, trade-offs, underutilisation of resources, efficiency, productivity, unemployment and economic growth',
                                                      instrument_type: 'Quiz',
                                                      creator: teacher,
                                                      subject: econ)

economic_systems_project = Instrument.create(title: 'Analyzing Economic Systems Project',
                                             description: 'A project that requires students to analyze how different economic systems attempt to resolve the three economic questions using real-world testples',
                                             instrument_type: 'Project',
                                             creator: teacher,
                                             subject: econ)

economic_fundamentals_test = Instrument.create(title: 'Economic Fundamentals Test',
                                               description: 'An test that covers all the fundamental concepts of economics including the basic economic problem, factors of production, income, production possibility curve, and different economic systems',
                                               instrument_type: 'Test',
                                               creator: teacher,
                                               subject: econ)

topic_1_1_instruments = [basic_economic_problem_quiz, factors_production_income_quiz, opportunity_cost_quiz,
                         production_possibility_curve_quiz, economic_systems_project, economic_fundamentals_test]

#====================================================================================================
# Topic 1.1 Assessments
#====================================================================================================
date = Date.new(2022, 9, 10)
topic_1_1_dates = [date]
5.times do
  date = topic_1_1_dates[-1] + 7
  topic_1_1_dates.push(date)
end

def assessment_weight(instrument_type)
  case instrument_type
  when 'Quiz'
    0.125
  when 'Test'
    0.25
  when 'Project'
    0.25
  when 'Exam'
    0.25
  when 'Essay'
    0.25
  end
end

topic_1_1_instruments.each_with_index do |instrument, index|
  new_assessment = Assessment.create(instrument:, unit: topic_1_1, date: topic_1_1_dates[index],
                                     weight: assessment_weight(instrument.instrument_type), description: instrument.description)
  p new_assessment
end

#====================================================================================================
# Topic 1.2 Instruments
#====================================================================================================

key_economic_terminology_quiz = Instrument.create(title: 'Key Economic Terminology Quiz',
                                                  description: 'Used to assess the students understanding of key concepts in economics, including aggregate demand, aggregate supply, circular flow of income model, consumption, exports, government expenditure, gross domestic product (GDP), imports, investment, subsidy and taxes.',
                                                  instrument_type: 'Quiz',
                                                  creator: teacher,
                                                  subject: econ)

circular_flow_income_quiz = Instrument.create(title: 'The Circular Flow of Income Model Quiz',
                                              description: 'Used to assess the students understanding of construction and significance of the five-sector circular flow of income model, including the relationships between the sectors, injections and withdrawals, and equilibrium conditions.',
                                              instrument_type: 'Quiz',
                                              creator: teacher,
                                              subject: econ)

government_economic_flows_quiz = Instrument.create(title: 'Government Decisions and Economic Flows Quiz',
                                                   description: 'Used to assess the students understanding of how government spending and taxation impact the economy using aggregate demand and the circular flow of income model, and how changes in the cash rate by the Reserve Bank of Australia affect aggregate demand and the circular flow of income.',
                                                   instrument_type: 'Quiz',
                                                   creator: teacher,
                                                   subject: econ)

factors_aggregate_supply_quiz = Instrument.create(title: 'Factors of Aggregate Supply and Economic Growth Quiz',
                                                  description: 'Used to assess the students understanding of the effects of changes in factors of aggregate supply on the circular flow of income model and how it relates to economic growth and employment. The quiz will also analyse and evaluate how current and topical economic events impact economic flows and draw conclusions or make decisions.',
                                                  instrument_type: 'Quiz',
                                                  creator: teacher,
                                                  subject: econ)

economic_flows_test = Instrument.create(title: 'Economic Flows Test',
                                        description: 'An test that covers all the concepts of economic flows including the circular flow of income model, government decisions, aggregate demand and supply and effects of various factors on the economy',
                                        instrument_type: 'Test',
                                        creator: teacher,
                                        subject: econ)

economic_flows_project = Instrument.create(title: 'Analyzing Economic Flows in Real World',
                                           description: 'A project that requires students to analyze current and topical economic events and their impact on various economic flows, and draw conclusions or make decisions based on the analysis',
                                           instrument_type: 'Project',
                                           creator: teacher,
                                           subject: econ)

topic_1_2_instruments = [key_economic_terminology_quiz, circular_flow_income_quiz,
                         government_economic_flows_quiz, factors_aggregate_supply_quiz, economic_flows_test, economic_flows_project]

#====================================================================================================
# Topic 1.2 Assessments
#====================================================================================================
date = topic_1_1_dates[-1] + 7
topic_1_2_dates = [date]
5.times do
  date = topic_1_2_dates[-1] + 7
  topic_1_2_dates.push(date)
end

topic_1_2_instruments.each_with_index do |instrument, index|
  new_assessment = Assessment.create(instrument:, unit: topic_1_2, date: topic_1_2_dates[index],
                                     weight: assessment_weight(instrument.instrument_type), description: instrument.description)
  p new_assessment
end

# Topic 1.3 instruments

market_forces_quiz = Instrument.create(title: 'Market Forces Quiz',
                                       description: 'This quiz will test students understanding of the forces of demand and supply that underlie the operation of the price mechanism in the economy, including the concepts of shortages, surpluses and elasticities.',
                                       instrument_type: 'Quiz',
                                       creator: teacher,
                                       subject: econ)

equilibrium_elasticity_quiz = Instrument.create(title: 'Equilibrium and Elasticity Quiz',
                                                description: 'This quiz will test students understanding of market equilibrium and the concept of elasticity of demand and supply.',
                                                instrument_type: 'Quiz',
                                                creator: teacher,
                                                subject: econ)

market_characteristics_quiz = Instrument.create(title: 'Market Characteristics Quiz',
                                                description: 'This quiz will test students understanding of the different characteristics of goods and services, including private, public, merit, substitute and complementary',
                                                instrument_type: 'Quiz',
                                                creator: teacher,
                                                subject: econ)

market_analysis_quiz = Instrument.create(title: 'Market Analysis Quiz',
                                         description: 'This quiz will test students understanding of analyzing market situations that are not in equilibrium in the short term, and expressing graphically to demonstrate shortage and surplus',
                                         instrument_type: 'Quiz',
                                         creator: teacher,
                                         subject: econ)

market_supply_shock_essay = Instrument.create(title: 'Market Forces and Supply Shocks Essay',
                                              description: 'This essay will require students to analyze the effects of a supply shock on market forces, including changes in prices and quantities, and the potential implications for both consumers and producers.',
                                              instrument_type: 'Essay',
                                              creator: teacher,
                                              subject: econ)

market_forces_test = Instrument.create(title: 'Market Forces Test',
                                       description: 'This test will test students understanding of the key concepts and subject matter covered in Topic 3 including market forces, market equilibrium, elasticity of demand and supply, and the characteristics of goods and services.',
                                       instrument_type: 'Test',
                                       creator: teacher,
                                       subject: econ)
topic_1_3_instruments = [market_forces_quiz, equilibrium_elasticity_quiz, market_characteristics_quiz,
                         market_analysis_quiz, market_supply_shock_essay, market_forces_test]
#====================================================================================================
# Topic 1.3 Assessments
#====================================================================================================
date = topic_1_2_dates[-1] + 7
topic_1_3_dates = [date]
5.times do
  date = topic_1_3_dates[-1] + 7
  topic_1_3_dates.push(date)
end
topic_1_3_instruments.each_with_index do |instrument, index|
  new_assessment = Assessment.create(instrument:, unit: topic_1_3, date: topic_1_3_dates[index],
                                     weight: assessment_weight(instrument.instrument_type), description: instrument.description)
  p new_assessment
end

#====================================================================================================
# Final exam instrument
#====================================================================================================
markets_and_models_exam = Instrument.create(title: 'Markets and Models Exam',
                                            description: 'This final exam will test students understanding of key economic concepts from Topic 1, Topic 2 and Topic 3, including scarcity, choices, economic flows, market forces, and elasticity of demand and supply.',
                                            instrument_type: 'Exam',
                                            creator: teacher,
                                            subject: econ)

#====================================================================================================
# Final Exam Assessment
#====================================================================================================

p Assessment.create(instrument: markets_and_models_exam, unit: unit_1, date: topic_1_3_dates[-1] + 7,
                    weight: assessment_weight(markets_and_models_exam.instrument_type), description: markets_and_models_exam.description)

unit_1_instruments = topic_1_1_instruments + topic_1_2_instruments + topic_1_3_instruments + [markets_and_models_exam]

#====================================================================================================
#
#
#
#
#
#
#====================================================================================================
#====================================================================================================
# Unit 2
#====================================================================================================

#====================================================================================================
# Unit 2.1 instruments
#====================================================================================================

market_failure_quiz = Instrument.create(title: 'Market Failure Quiz',
                                        description: 'This quiz will test students understanding of the causes and effects of market failure, including excesses of boom and bust cycles, externalities, market power, public goods, and asymmetric information.',
                                        instrument_type: 'Quiz',
                                        creator: teacher,
                                        subject: econ)

market_modification_quiz = Instrument.create(title: 'Market Modification Quiz',
                                             description: 'This quiz will test students understanding of different methods of market modification required to correct market failure, including direct and indirect taxation, subsidies, price floors/ceilings, and regulation.',
                                             instrument_type: 'Quiz',
                                             creator: teacher,
                                             subject: econ)

property_rights_quiz = Instrument.create(title: 'Property Rights Quiz',
                                         description: 'This quiz will test students understanding of how the extension of property rights may resolve economic inefficiencies associated with common resources and the tension between the costs to society of market failure and the unintended consequences of possible mitigation methods.',
                                         instrument_type: 'Quiz',
                                         creator: teacher,
                                         subject: econ)

market_efficiency_quiz = Instrument.create(title: 'Market Efficiency Quiz',
                                           description: 'This quiz will cover the concept of market efficiency, including allocative efficiency, productive efficiency, and dynamic efficiency. It will also explore the causes and effects of market failure, as well as methods for correcting market failure.',
                                           instrument_type: 'Quiz',
                                           creator: teacher,
                                           subject: econ)

market_failure_research_project = Instrument.create(title: 'Market Failure Research Project',
                                                    description: 'This project will require students to conduct research on a specific market failure and analyze the causes and effects of the market failure, as well as potential methods of correction.',
                                                    instrument_type: 'Project',
                                                    creator: teacher,
                                                    subject: econ)

markets_efficiency_test = Instrument.create(title: 'Markets and Efficiency Final Exam',
                                            description: 'This exam will cover the material from Topic 1: Markets and Efficiency, including key concepts such as allocative efficiency, market failure, and methods of correction.',
                                            instrument_type: 'Test',
                                            creator: teacher,
                                            subject: econ)

topic_2_1_instruments = [market_failure_quiz, market_modification_quiz, property_rights_quiz, market_efficiency_quiz,
                         market_failure_research_project, markets_efficiency_test]

#====================================================================================================
# Unit 2.1 Assessments
#====================================================================================================
date = topic_1_3_dates[-1] + 7
topic_2_1_dates = [date]
5.times do
  date = topic_2_1_dates[-1] + 7
  topic_2_1_dates.push(date)
end
topic_2_1_instruments.each_with_index do |instrument, index|
  new_assessment = Assessment.create(instrument:, unit: topic_2_1, date: topic_2_1_dates[index],
                                     weight: assessment_weight(instrument.instrument_type), description: instrument.description)
  p new_assessment
end

#====================================================================================================
# Unit 2.2 Instruments
#====================================================================================================

ecological_sustainable_development_quiz = Instrument.create(title: 'Ecologically Sustainable Development Quiz',
                                                            description: 'This quiz will assess the students understanding of ecologically sustainable development and its relationship to allocative, productive, and dynamic efficiency.',
                                                            instrument_type: 'Quiz',
                                                            creator: teacher,
                                                            subject: econ)

environmental_impacts_quiz = Instrument.create(title: 'Environmental Impacts of Economic Activities Quiz',
                                               description: 'This quiz will assess the students understanding of the environmental impacts of economic activities and the trade-offs between economic growth and ecologically sustainable development.',
                                               instrument_type: 'Quiz',
                                               creator: teacher,
                                               subject: econ)

valuing_externalities_quiz = Instrument.create(title: 'Valuing Externalities Quiz',
                                               description: 'This quiz will assess the students understanding of the challenge of valuing externalities and ensuring they are reflected in market prices.',
                                               instrument_type: 'Quiz',
                                               creator: teacher,
                                               subject: econ)

environmental_degradation_test = Instrument.create(title: 'Environmental Degradation in Australia Test',
                                                   description: 'This test will assess the students understanding of environmental degradation in Australia and the underlying assumptions and perspectives of the different sources of information.',
                                                   instrument_type: 'Test',
                                                   creator: teacher,
                                                   subject: econ)

government_strategies_project = Instrument.create(title: 'Government Strategies for Redressing Environmental Degradation Project',
                                                  description: 'This project will require students to research and analyze government strategies and/or interventions to redress environmental degradation and significant measures to achieve economic and ecological sustainability.',
                                                  instrument_type: 'Project',
                                                  creator: teacher,
                                                  subject: econ)

environmental_economics_essay = Instrument.create(title: 'Environmental Economics Essay',
                                                  description: 'In this essay, students will analyze and evaluate the trade-off between economic growth and ecologically sustainable development, using data and economic information from sources such as the environmental performance index and the environmental Kuznets curve. They will also examine government strategies and interventions to address environmental degradation and determine socially optimal levels of production and consumption.',
                                                  instrument_type: 'Essay',
                                                  creator: teacher,
                                                  subject: econ)
topic_2_2_instruments = [ecological_sustainable_development_quiz, environmental_impacts_quiz,
                         valuing_externalities_quiz, environmental_degradation_test, government_strategies_project, environmental_economics_essay]

#====================================================================================================
# Unit 2.1 Assessments
#====================================================================================================
date = topic_2_1_dates[-1] + 7
topic_2_2_dates = [date]
5.times do
  date = topic_2_2_dates[-1] + 7
  topic_2_2_dates.push(date)
end
topic_2_2_instruments.each_with_index do |instrument, index|
  new_assessment = Assessment.create(instrument:, unit: topic_2_2, date: topic_2_2_dates[index],
                                     weight: assessment_weight(instrument.instrument_type), description: instrument.description)
  p new_assessment
end
#====================================================================================================
# Unit 2 Final Exam
#====================================================================================================

market_efficiency_and_environmental_economics_exam = Instrument.create(title: 'Market Efficiency and Environmental Economics Exam',
                                                                       description: 'This exam will test students on their understanding of market forces and efficiency, as well as their knowledge of the environmental impacts of economic activities and strategies for achieving economic and ecological sustainability.',
                                                                       instrument_type: 'Exam',
                                                                       creator: teacher,
                                                                       subject: econ)

p Assessment.create(instrument: market_efficiency_and_environmental_economics_exam, unit: unit_2,
                    date: topic_2_2_dates[-1] + 7, weight: assessment_weight(market_efficiency_and_environmental_economics_exam.instrument_type), description: market_efficiency_and_environmental_economics_exam.description)

unit_2_instruments = topic_2_1_instruments + topic_2_2_instruments + [market_efficiency_and_environmental_economics_exam]

assessments = Assessment.all
students = StudentProfile.all

assessments.each do |assessment|
  students.each do |student|
    rand_grade = rand.round(2) * 1.1
    p rand_grade
    rand_grade = 1 if rand_grade > 1
    p Grade.create(assessment:, student:, score: rand_grade.round(2))
  end
end
