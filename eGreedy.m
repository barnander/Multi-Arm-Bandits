classdef eGreedy
    %EGREEDY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        n_arms {mustBeInteger, mustBePositive} %number of advert campains
        epsilon {mustBeInRange(epsilon, 0,1)} 
        scores %probability of a click on ad
        choices %how many times each ad is chosen (1xn array)
    end
    
    methods
        function obj = eGreedy(n_arms, epsilon)
            %EGREEDY Construct an instance of this class
            obj.n_arms = n_arms; 
            obj.epsilon = epsilon; 
            obj.scores = ones(1,n_arms);
            obj.choices = zeros(1,n_arms);
            
        end
        
        function choice = choose(obj)
            %Choice of ad for iteration
            if rand <= obj.epsilon
                choice = randi(obj.n_arms);
            else 
                [~,choice] = max(obj.scores(end,:));
            end
        end

        function obj = update(obj, choice, click)
            %Updates the probability of success after each showing of the
            %ad
            %   -choice is the ad chosen by the chose function (must be an
            %integer value for the moment)
            %   -click is either a 1 or a 0 
            no_choices = obj.choices(choice); %number of times the ad has already been chosen
            score = obj.scores;
            current_p = obj.scores(end, choice); %current click probability of ad
            new_p = (current_p * no_choices + click) / (no_choices+1); %compute new probability 
            
            obj.scores(end+1, : ) = obj.scores(end, : ); %copy last line of scores into new line
            obj.scores(end, choice) = new_p; %add new probability to ad's column

            obj.choices(choice) = no_choices + 1;
        end
            
    end
end