require 'rails_helper'
 
RSpec.describe SoftDeleter do
  let!(:user_1) { User.create(name: "Test", email: "test@test.com") }
  let!(:book_1) { user_1.books.create(name: "Yoitomake") }
  let!(:section_1) { book_1.sections.create(title: "Start!") }
  let!(:section_2) { book_1.sections.create(title: "ReadyToGo") }
  let!(:book_2) { user_1.books.create(name: "AllNight") }
  let!(:section_3) { book_2.sections.create(title: "Wait a minute") }
  let!(:section_4) { book_2.sections.create(title: "way to sleep well") }

  let!(:user_2) { User.create(name: "Oest", email: "oest@oest.com") }
  let!(:book_3) { user_2.books.create(name: "LastNight") }
  let!(:section_5) { book_3.sections.create(title: "sleep well") }
  let!(:section_6) { book_3.sections.create(title: "go to zz") }
  let!(:section_7) { book_3.sections.create(title: "go ahead") }

  let!(:admin) { Admin.create(name: "admin") }

  describe "patern when user is soft_deleted" do
    subject { user_1.soft_delete }

    context "books and sections are soft_deleted when user is soft_deleted" do
      it "user_1 is soft_deleted" do
        expect { subject }.to change { User.enabled.all.count }.from(2).to(1)
      end
  
      it "user_1's books are soft_deleted" do
        expect { subject }.to change { user_1.books.enabled.count }.from(2).to(0)
      end
  
      it "book_1's sections are soft_deleted" do
        expect { subject }.to change { book_1.sections.enabled.count }.from(2).to(0)
      end
  
      it "book_2's sections are soft_deleted" do
        expect { subject }.to change { book_2.sections.enabled.count }.from(2).to(0)
      end
  
      it "user_2's books are alive" do
        expect { subject }.not_to change { user_2.books.enabled.count }
      end
  
      it "book_3's sections are alive" do
        expect { subject }.not_to change { book_3.sections.enabled.count }
      end
    end
  end

  describe "patern when user is soft_deleted!" do
    subject { user_1.soft_delete! }

    context "books and sections are soft_deleted when user is soft_deleted!" do
      it "user_1 is soft_deleted!" do
        expect { subject }.to change { User.enabled.all.count }.from(2).to(1)
      end
  
      it "user_1's books are soft_deleted!" do
        expect { subject }.to change { user_1.books.enabled.count }.from(2).to(0)
      end
  
      it "book_1's sections are soft_deleted!" do
        expect { subject }.to change { book_1.sections.enabled.count }.from(2).to(0)
      end
  
      it "book_2's sections are soft_deleted!" do
        expect { subject }.to change { book_2.sections.enabled.count }.from(2).to(0)
      end
  
      it "user_2's books are alive" do
        expect { subject }.not_to change { user_2.books.enabled.count }
      end
  
      it "book_3's sections are alive" do
        expect { subject }.not_to change { book_3.sections.enabled.count }
      end
    end
  end

  describe "restore check" do
    before do
      user_1.soft_delete
    end

    subject { user_1.restore }

    context "books and sections are restored when user is restored" do
      it "user_1 is soft_deleted!" do
        expect { subject }.to change { User.enabled.all.count }.from(1).to(2)
      end
  
      it "user_1's books are restored" do
        expect { subject }.to change { user_1.books.enabled.count }.from(0).to(2)
      end
  
      it "book_1's sections are restored" do
        expect { subject }.to change { book_1.sections.enabled.count }.from(0).to(2)
      end
  
      it "book_2's sections are restored" do
        expect { subject }.to change { book_2.sections.enabled.count }.from(0).to(2)
      end
  
      it "user_2's books are alive" do
        expect { subject }.not_to change { user_2.books.enabled.count }
      end
  
      it "book_3's sections are alive" do
        expect { subject }.not_to change { book_3.sections.enabled.count }
      end
    end
  end

  describe "#deleter_type" do
    context "no arguments" do
      before do
        user_1.soft_delete
      end

      it "self class is setted" do
        expect(user_1.deleter_type).to eq User
      end
    end

    context "arguments exits" do
      before do
        user_1.soft_delete(admin)
      end

      it "admin is setted" do
        expect(user_1.deleter_type).to eq Admin
      end
    end

    context "when not soft deleted" do
      it "will return nil" do
        expect(user_1.deleter_type).to eq nil
      end
    end
  end

  describe "#deleter_id" do
    context "no arguments" do
      before do
        user_1.soft_delete
      end

      it "self.id is setted" do
        expect(user_1.deleter_id).to eq user_1.id
      end
    end

    context "arguments exits" do
      before do
        user_1.soft_delete(admin)
      end

      it "admin.id is setted" do
        expect(user_1.deleter_id).to eq admin.id
      end
    end

    context "when not soft deleted" do
      it "will return nil" do
        expect(user_1.deleter_id).to eq nil
      end
    end
  end

  describe "#soft_deleted?" do
    context "when soft deleted" do
      before do
        user_1.soft_delete
      end
  
      it "is true" do
        expect(user_1.soft_deleted?).to be_truthy
      end
    end

    context "when not deleted" do
      it "is true" do
        expect(user_1.soft_deleted?).to be_falsey
      end
    end
  end

  describe "#alive?" do
    context "when soft deleted" do
      before do
        user_1.soft_delete
      end
  
      it "is true" do
        expect(user_1.alive?).to be_falsey
      end
    end

    context "when not deleted" do
      it "is true" do
        expect(user_1.alive?).to be_truthy
      end
    end
  end

  describe "soft_delete response" do
    context "soft_delete" do
      it "be true" do
        expect(user_1.soft_delete).to be_truthy
      end
    end
  end

  describe "#deleter" do
    context "when soft deleted" do
      before do
        user_1.soft_delete(admin)
      end
  
      it "can find soft_delete user" do
        expect(user_1.deleter).to eq admin
      end
    end

    context "when not soft deleted" do
      it "will return nil" do
        expect(user_1.deleter).to eq nil
      end
    end
  end
end
