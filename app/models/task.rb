# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  due_date    :date
#  category_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :bigint           not null
#  code        :string
#
class Task < ApplicationRecord
  belongs_to :category
  belongs_to :owner, class_name: 'User'
  has_many :participating_users, class_name: 'Participant' , dependent: :destroy
  has_many :participants, through: :participating_users, source: :user
  has_many :notes

  validates :name, :description, presence: true
  validates :name, uniqueness: {case_insensitive: false}
  validate :due_date_validity
  validate :user_no_repeat

  before_create :create_code
  after_create :send_email

  accepts_nested_attributes_for :participating_users


  def due_date_validity
    return if due_date.blank?
    return if due_date > Date.today
    errors.add :due_date, I18n.t('task.errors.invalid_due_date')
  end

  def user_no_repeat
    user_ids = participating_users.map(&:user_id)
   
    if user_ids.detect{|u| user_ids.count(u) > 1}
      errors.add :base, I18n.t('task.errors.user_repeated')
    end
  end

  def create_code
    self.code ="#{owner_id}#{Time.now.to_i.to_s(36)}#{SecureRandom.hex(8)}"
  end

  def send_email
    (participants + [owner]).each do |user|
      ParticipantMailer.with(user: user, task: self).new_task_email.deliver!
    end
  end  
end
