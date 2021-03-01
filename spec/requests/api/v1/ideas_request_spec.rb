require "rails_helper"

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
          expect(json["data"].size).to eq 2
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
        expect(json["data"].size).to eq 3
      end
    end

    context "category_name以外のパラメータが存在する場合" do
      it "ideaを全て返すこと" do
        get api_v1_ideas_path, params: { hogehoge: "テスト" }

        expect(response.status).to eq 200
        expect(json["data"].size).to eq 3
      end
    end
  end

  describe "create_action" do
    before do
      @category1 = Category.create!(name: "アプリ")
    end

    context "category_nameをもつcategoryが存在する場合" do
      context "リクエストが正常な場合" do
        it "categoryに紐づくideaを登録すること" do
          expect { post api_v1_ideas_path, params: { category_name: @category1.name, body: "家計簿アプリ" } }.to change { Idea.count }.by(+1)
          expect(response.status).to eq 201
        end
      end

      context "リクエストが正常でない場合" do
        it "保存に失敗しステータスコード422を返すこと" do
          expect { post api_v1_ideas_path, params: { category_name: @category1.name, body: " " } }.to change { Idea.count }.by(0)
          expect(response.status).to eq 422
        end
      end
    end

    context "category_nameをもつcategoryが存在しない場合" do
      it "新しくcategoryとcategoryに紐づくideaを登録すること" do
        expect { post api_v1_ideas_path, params: { category_name: "スポーツ", body: "サッカー" } }.to change { Idea.count }.by(+1).and change { Category.count }.by(1)
        expect(response.status).to eq 201
      end
    end

    context 'category_nameが空である場合' do
      it 'ステータスコード422を返し、保存に失敗すること' do
        expect { post api_v1_ideas_path, params: { category_name: ' ', body: 'バスケットボール' } }.to change { Idea.count }.by(0).and change { Category.count }.by(0)
        expect(response.status).to eq 422
      end
    end

    context '新たなcategory_nameが存在し、bodyが空である場合' do
      it 'ステータスコード422を返し、保存に失敗すること' do
        expect { post api_v1_ideas_path, params: { category_name: '健康', body: ' ' } }.to change { Idea.count }.by(0).and change { Category.count }.by(0)
        expect(response.status).to eq 422
      end
    end
  end
end
