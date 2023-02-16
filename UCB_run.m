classdef UCB_run <handle
    %main class is used to run the loop over n trials
    %will use eGreedy and also ad_Bandit classes

    %the easiest way to run this code is to create an instance of the main
    %class (i.e. x = main). Then x.run in the command window will produce
    %a table of the scores and a plot to visualise what is happening
    
    properties 
        ad_Campaigns
        myUCB
        n_trials
        regret
    end


    methods
        function obj = UCB_run() %initialise object
            obj.ad_Campaigns = ad_Bandit([0.28,0.35,0.4]); %bandit should have probabilities passed into it - if not will still run (see inside this class)
            obj.myUCB = UCB(obj.ad_Campaigns.N); %inputs to UCB are number of ad campaigns
            obj.n_trials = 1000;
            obj.regret = [];
        end
    

        function run(obj)
            ad_names = string( (1:obj.ad_Campaigns.N) );
            success = 0;
            
            for i = 1: obj.n_trials-1
                ad_choice = obj.myUCB.choose();
                click = obj.ad_Campaigns.test(ad_choice);

                obj.myUCB = obj.myUCB.update(ad_choice, click);
                
                regret_i = sum(obj.myUCB.choices .* obj.ad_Campaigns.probs) - i* max(obj.ad_Campaigns.probs);
                obj.regret(end+1) = regret_i;
                
                scores = obj.myUCB.scores;
                scores_table = array2table(scores);
                scores_table.Properties.VariableNames = ad_names;
               
            end
        end
    end

end