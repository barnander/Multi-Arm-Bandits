classdef eDecrease_run <handle
    %main class is used to run the loop over n trials
    %will use eGreedy and also ad_Bandit classes

    %the easiest way to run this code is to create an instance of the main
    %class (i.e. x = main). Then x.run in the command window will produce
    %a table of the scores and a plot to visualise what is happening
    
    properties 
        ad_Campaigns
        myGreedy
        n_trials
        regret
        e_func %function of i to determine epsilon
    end


    methods
        function obj = eDecrease_run() %initialise object
            obj.ad_Campaigns = ad_Bandit([0.28,0.35,0.4]); %bandit should have probabilities passed into it - if not will still run (see inside this class)
            obj.myGreedy = eGreedy(obj.ad_Campaigns.N, 0.1); %inputs to eGreedy are number of ad campaigns and value of epsilon 
            obj.n_trials = 1000;
            obj.regret = [];
            obj.e_func = @(x) 1./(x.^.5);
        end
    

        function run(obj)
            ad_names = string( (1:obj.ad_Campaigns.N) );
            success = 0;
            
            for i = 1: obj.n_trials-1
                epsilon = obj.e_func(i);
                obj.myGreedy.epsilon = epsilon;

                ad_choice = obj.myGreedy.choose();
                click = obj.ad_Campaigns.test(ad_choice);
                success = success + click;

                obj.myGreedy = obj.myGreedy.update(ad_choice, click);
                obj.regret(end+1) = success - i*max(obj.ad_Campaigns.probs);
                
                scores = obj.myGreedy.scores;
                scores_table = array2table(scores);
                scores_table.Properties.VariableNames = ad_names;
               
            end
        end
    end

end