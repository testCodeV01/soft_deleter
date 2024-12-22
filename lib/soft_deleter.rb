require "soft_deleter/version"
require "soft_deleter/railtie"

module SoftDeleter
  extend ActiveSupport::Concern

  included do
    scope :enabled, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }
  end

  class_methods do
    def included_tables
      result = %i[has_many has_one].map { |a| self.reflect_on_all_associations(a) }.flatten.filter_map do |i|
        next unless %i[destroy delete delete_all].include?(i.options[:dependent]) && i.options.keys.exclude?(:through)

        i.options[:class_name]&.underscore&.pluralize&.to_sym || i.name
      end.compact
      result - [:"active_storage/attachments"]
    end
  end

  def soft_delete!(deleter = self)
    ActiveRecord::Base.transaction do
      with_associations(:soft_delete_witout_associations!, deleter)
    end

    true
  end

  def soft_delete(deleter = self)
    ActiveRecord::Base.transaction do
      with_associations(:soft_delete_witout_associations, deleter)
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def restore!
    ActiveRecord::Base.transaction do
      with_associations(:restore_without_associations!)
    end

    true
  end

  def restore
    ActiveRecord::Base.transaction do
      with_associations(:restore_without_associations)
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def deleter_type
    self[:deleter_type].constantize if self.soft_deleted?
  end

  def soft_deleted?
    self.deleted_at.present?
  end

  def alive?
    self.deleted_at.nil?
  end

  def deleter
    self.deleter_type&.find_by(id: self.deleter_id)
  end

  protected

  def with_associations(callback, deleter = nil)
    child_tables = self.class.included_tables
    childs = child_tables.map do |child_table|
      self.send(child_table)
    end.flatten

    childs.compact.each { |child| child.with_associations(callback, deleter) }

    send(callback, deleter) if deleter.present?
    send(callback) if deleter.blank?
  end

  private

  def soft_delete_witout_associations!(deleter)
    raise ActiveRecord::RecordInvalid, self if invalid?

    update!(
      deleter_type: deleter.class.to_s,
      deleter_id: deleter.id,
      deleted_at: Time.zone.now
    )
  end

  def soft_delete_witout_associations(deleter)
    raise ActiveRecord::RecordInvalid if invalid?

    update(
      deleter_type: deleter.class.to_s,
      deleter_id: deleter.id,
      deleted_at: Time.zone.now
    )
  end

  def restore_without_associations!
    raise ActiveRecord::RecordInvalid, self if invalid?

    update(
      deleter_type: nil,
      deleter_id: nil,
      deleted_at: nil
    )
  end

  def restore_without_associations
    raise ActiveRecord::RecordInvalid if invalid?

    update(
      deleter_type: nil,
      deleter_id: nil,
      deleted_at: nil
    )
  end
end
