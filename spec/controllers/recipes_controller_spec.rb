require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  render_views
  describe 'index' do
    before do
      Recipe.create!(name: 'Baked Potato w/ Cheese')
      Recipe.create!(name: 'Garlic Mashed Potatoes')
      Recipe.create!(name: 'Potatoes Au Gratin')
      Recipe.create!(name: 'Baked Brussel Sprouts')

      get :index, params: { keywords: keywords }, xhr: true, format: :json
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_name
      ->(object) { object['name'] }
    end

    context 'when the search finds results' do
      let(:keywords) { 'baked' }
      it 'should 200' do
        expect(response.status).to eq(200)
      end
      it 'should return two results' do
        expect(results.size).to eq(2)
      end
      it "should include 'Baked Potato w/ Cheese'" do
        expect(results.map(&extract_name)).to include('Baked Potato w/ Cheese')
      end
      it "should include 'Baked Brussel Sprouts'" do
        expect(results.map(&extract_name)).to include('Baked Brussel Sprouts')
      end
    end

    context "when the search doesn't find results" do
      let(:keywords) { 'foo' }
      it 'should return no results' do
        expect(results.size).to eq(0)
      end
    end
  end

  describe 'show' do
    before do
      get :show, params: { id: recipe_id }, xhr: true, format: :json
    end

    subject(:results) { JSON.parse(response.body) }

    context 'when the recipe exists' do
      let(:recipe) do
        Recipe.create!(name: 'Baked Potato w/ Cheese',
                       instructions: 'Nuke for 20 minutes; top with cheese')
      end
      let(:recipe_id) { recipe.id }

      it { expect(response.status).to eq(200) }
      it { expect(results['id']).to eq(recipe.id) }
      it { expect(results['name']).to eq(recipe.name) }
      it { expect(results['instructions']).to eq(recipe.instructions) }
    end

    context "when the recipe doesn't exit" do
      let(:recipe_id) { -9999 }
      it { expect(response.status).to eq(404) }
    end
  end

  describe 'create' do
    before do
      post :create, params: { recipe: { name: 'Toast', instructions: 'Add bread to toaster, push lever' } }, xhr: true, format: :json
    end
    it { expect(response.status).to eq(201) }
    it { expect(Recipe.last.name).to eq('Toast') }
    it { expect(Recipe.last.instructions).to eq('Add bread to toaster, push lever') }
  end

  describe 'update' do
    let(:recipe) do
      Recipe.create!(name: 'Baked Potato w/ Cheese',
                     instructions: 'Nuke for 20 minutes; top with cheese')
    end
    before do
      put :update, params: { id: recipe.id, recipe: { name: 'Toast',
                                                      instructions: 'Add bread to toaster, push lever' } }, xhr: true, format: :json
      recipe.reload
    end
    it { expect(response.status).to eq(204) }
    it { expect(recipe.name).to eq('Toast') }
    it { expect(recipe.instructions).to eq('Add bread to toaster, push lever') }
  end

  describe 'destroy' do
    let(:recipe_id) do
      Recipe.create!(name: 'Baked Potato w/ Cheese',
                     instructions: 'Nuke for 20 minutes; top with cheese').id
    end
    before do
      delete :destroy, params: { id: recipe_id }, xhr: true, format: :json
    end
    it { expect(response.status).to eq(204) }
    it { expect(Recipe.find_by_id(recipe_id)).to be_nil }
  end
end
