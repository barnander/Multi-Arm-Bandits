classdef ad_Bandit
    %BANDIT simulates a multi-armed bandit with binary reward
    
    properties
        probs        % probability of success on each advertising campaign
        N            % number of advertising campaigns
    end
    
    methods
        function self = ad_Bandit(probs)       % initialise object
            if nargin < 1                      % if no user input - not needed aslong user does input the property of probs
                self.probs = [.28 .32 .26]; % use default (if nothing specified) 
                self.N = 3;                 % use default (can be changes)
            else                            % otherwise use the user's input
                self.probs = probs;        
                self.N = length(probs);     
            end
        end
        
        function reward =  test(self,arm)   % calculate the reward
            %rand used below to randomly pick a number between 0 and 1
            reward = rand < self.probs(arm);% reward is 1 or 0
        end
    end
    
end