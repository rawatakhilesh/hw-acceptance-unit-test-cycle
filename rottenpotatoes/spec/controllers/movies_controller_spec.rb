require 'rails_helper'

RSpec.describe MoviesController, type: :controller do

    before do
        @test_movie = double('movie1', :id  => 20, :title => 'Wasseypur', :director => 'Anurag Kashyap')    
        @test_results = [@test_movie, double('movie2', :id => 29, :title => 'Black Friday', :director => 'Anurag Kashyap')]
    end
    
    describe "#find_similar" do
        it "should call model to find similar movies" do
            Movie.should_receive(:find).with("20").and_return(@test_movie)
            Movie.should_receive(:where).with({:director=>"Anurag Kashyap"}).and_return(@test_results)
            post :find_similar, {:movie_id => "20"}      
        end       
    
        before do
            Movie.stub(:find).with("20").and_return(@test_movie)
            Movie.stub(:where).with({:director=>"Anurag Kashyap"}).and_return(@test_results)
            post :find_similar, {:movie_id => "20"}
            
        end
        
        it "should redirect to similar movie page" do
            response.should render_template("find_similar")
        end 
        
        describe 'sad path' do
            before do
                Movie.stub(:find).with("20").and_return(@test_movie)
                Movie.stub(:where).with({:director=>"Anurag Kashyap"}).and_return(nil)
                post :find_similar, {:movie_id => "20"}
            end
            it "should redirect to home page and flash" do
                response.should redirect_to(movies_path) 
            end
        
            it "should flash no director info notice" do
                flash[:notice].should =~ /Wasseypur has no director info./ 
            end    
        end
   end
end
