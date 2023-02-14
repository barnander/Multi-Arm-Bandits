% run eGreedy model + plots
e_Greedy = eGreedy_run;
e_Greedy.n_trials = 2000;
e_Greedy.run


figure
hold on
x = 1:e_Greedy.n_trials;
            
for i = 1:e_Greedy.ad_Campaigns.N
    plot(x, [e_Greedy.myGreedy.scores(:,i)]', 'LineWidth',2);
    xlabel('number of trials'); ylabel('expected reward'); 
    title('Epsilon-greedy strategy for Ad Campaigns');
            end
legend(["Ad1", "Ad2", "Ad3"])
hold off

figure 
plot(1:e_Greedy.n_trials - 1, e_Greedy.regret)
xlabel("Trial")
ylabel("Regret")
title("Regret over 1000 trials")

%% plots regret for different epsilon values for eGreedy
epsilons = 0:0.1: 0.5;
x = 1:100;

figure
hold on
for epsilon = epsilons
    regrets = [];
    for i = x
        e_Greedy = eGreedy_run;
        e_Greedy.n_trials = 100;
        e_Greedy.myGreedy.epsilon = epsilon;
        e_Greedy.run
        regrets(i,:) = e_Greedy.regret;
    end
    epsilon
    plot(mean(regrets))
    
end
xlabel("#Ads Shown")
ylabel("Regret")
legend(string(epsilons))
hold off
%% average regret over 10 experiments of 1000 trials and plot egreedy
regrets_greedy = [];
regrets_decreasing = [];
x = 1:50;
for i = x
    e_Greedy = eGreedy_run;
    e_Greedy.run
    regrets_greedy(end+1) = e_Greedy.regret(end);

    e_Decrease = eDecrease_run;
    e_Decrease.run
    regrets_decreasing(end+1) = e_Decrease.regret(end);
    i
end

scatter([1 2], [mean(regrets_greedy), mean(regrets_decreasing)])
%% plot edecreasing

plot_areaerrorbar(regrets_decreasing)

%%
% epsilons = [0.05,0.1,0.15];
% regret = [];
% x = 1:10;
% 
% for e = epsilons
%     for i = x
%         regret_i = [];
%         e_Greedy = eGreedy_run;
%         e_Greedy.myGreedy.epsilon = e;
%         e_Greedy.run;
%         regret_i(end+1) = e_Greedy.regret(end);
%         i
%     end
%     regret(end+1) = mean(regret_i);
%     e
% end
% 
% plot(epsilons,mean(regret))
