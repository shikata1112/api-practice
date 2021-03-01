require 'rails_helper'

RSpec.describe "Api::V1::Ideas", type: :request do

  describe "index_action" do
    before do
      @category1 = Category.create!(name: "アプリ")
      @category2 = Category.create!(name: "スポーツ")
      @category3 = Category.create!(name: "仕事")
      Idea.create!(category_id: @category1.id, body: "家計簿アプリ")
      Idea.create!(category_id: @category1.id, body: "勤怠管理アプリ")
      Idea.create!(category_id: @category2.id, body: "サッカー")
    end

    context "パラメータにcategory_nameが存在する場合" do
      context "category_nameをもつcategoryが存在する場合" do
        it "categoryに紐づくideaを全て返すこと" do
          get api_v1_ideas_path, params: { category_name: @category1.name }

          expect(response.status).to eq 200
          expect(json['data'].size).to eq 2
        end
      end

      context "category_nameをもつcategoryが存在しない場合" do
        it "ステータスコード404を返すこと" do
          get api_v1_ideas_path, params: { category_name: "テスト" }

          expect(response.status).to eq 404
        end
      end
    end
    
    context "パラメータにcategory_nameが存在しない場合" do
      it "ideaを全て返すこと" do
        get api_v1_ideas_path

        expect(response.status).to eq 200
        expect(json['data'].size).to eq 3
      end
    end

    context "category_name以外のパラメータが存在する場合" do
      it "ideaを全て返すこと" do
        get api_v1_ideas_path, params: { hogehoge: "テスト" }

        expect(response.status).to eq 200
        expect(json['data'].size).to eq 3
      end
    end
  end
end
