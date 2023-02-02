classdef main <handle
    %main class is used to run the loop over n trials
    %will use eGreedy and also ad_Bandit classes

    %the easiest way to run this code is to create an instance of the main
    %class (i.e. x = main). Then x.run in the command window will produce
    %a table of the scores and a plot to visualise what is happening
    
    properties 
        ad_Campaigns
        myGreedy
        n_trials   
    end


    methods
        function obj = main() %initialise object
            obj.ad_Campaigns = ad_Bandit([0.28,0.35,0.4]); %bandit should have probabilities passed into it - if not will still run (see inside this class)
            obj.myGreedy = eGreedy(obj.ad_Campaigns.N, 0.2); %inputs to eGreedy are number of ad campaigns and value of epsilon 
            obj.n_trials = 1000;  
        end
    

        function run(obj)
            ad_names = string( (1:obj.ad_Campaigns.N) );
            
            for i = 1: obj.n_trials-1
                ad_choice = obj.myGreedy.choose();
                click = obj.ad_Campaigns.test(ad_choice);

                obj.myGreedy = obj.myGreedy.update(ad_choice, click);
                
                scores = obj.myGreedy.scores;
                scores_table = array2table(scores);
                scores_table.Properties.VariableNames = ad_names;
               
            end
            disp(scores_table); %outputs table of scores where each row is a consecutive trial
            
            %following part simply plots a graph of the scores we have
            %obtained above against the number of trials. 
            hold on
            x = 1:obj.n_trials;
            
            for i = 1:obj.ad_Campaigns.N
                plot(x, [scores(:,i)]', 'LineWidth',2);
                xlabel('number of trials'); ylabel('expected reward'); 
                title('Eepsilon-greedy strategy for Ad Campaigns');
            end
            hold off 
            
        end
    end

end