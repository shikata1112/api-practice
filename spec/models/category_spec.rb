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
end