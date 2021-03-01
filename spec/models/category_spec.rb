require 'rails_helper'

RSpec.describe Category, type: :model do
  describe ".fetch_ideas" do
    before do
      @category1 = Category.create!(name: "アプリ")
      @category2 = Category.create!(name: "スポーツ")
      @category3 = Category.create!(name: "仕事")
      Idea.create!(category_id: @category1.id, body: "家計簿アプリ")
      Idea.create!(category_id: @category1.id, body: "勤怠管理アプリ")
      Idea.create!(category_id: @category2.id, body: "サッカー")
    end

    context "nameが存在する場合" do
      context "nameをもつcategoryが存在する場合" do
        it "categoryに紐づくideaを全て返すこと" do
          expect(Category.fetch_ideas("アプリ").size).to eq 2 
        end
      end

      context "nameをもつcategoryが存在しない場合" do
        it "空の配列を返すこと" do
          expect(Category.fetch_ideas("hogehoge")).to eq []
        end
      end
    end
    
    context "nameが存在しない場合" do
      it "Ideaを全て返すこと" do
        expect(Category.fetch_ideas(" ").size).to eq 3
      end
    end
  end

  describe '.create_ideas!' do
    before do
      @category1 = Category.create!(name: 'アプリ')
    end

    context 'categoryのnameが存在する場合' do
      it 'categoryに紐づくideaを作成できること' do
        Category.create_ideas!(@category1.name, 'test')

        expect(@category1.ideas.last.body).to eq 'test'
      end

      it '例外が発生すること' do
        expect { Category.create_ideas!(@category1.name, ' ') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'categoryのnameが存在しない場合' do
      it '新たなcategoryとideaが保存されること' do
        Category.create_ideas!('スポーツ', 'test')

        category = Category.find_by(name: 'スポーツ')
        expect(category.name).to eq 'スポーツ'
        expect(category.ideas.last.body).to eq 'test'
      end

      context 'nameが空の場合' do
        it '例外が発生すること' do
          expect { Category.create_ideas!(' ', 'test') }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'bodyが空の場合' do
        it '例外が発生すること' do
          expect { Category.create_ideas!('アプリ', ' ') }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'nameとbodyどちらも空の場合' do
        it '例外が発生すること' do
          expect { Category.create_ideas!(' ', ' ') }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end