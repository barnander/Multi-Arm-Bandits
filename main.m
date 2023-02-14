% run eGreedy model + plots
e_Greedy = eGreedy_run;
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
epsilons = 0:0.05: 0.25;
x = 1:10;

figure
hold on
for epsilon = epsilons
    for i = x
        e_Greedy = eGreedy_run;
        e_Greedy.myGreedy.epsilon = epsilon;
        e_Greedy.run
        regrets(i,:) = e_Greedy.regret;
    end
    
    plot(mean(regrets))
    epsilon
end
xlabel("#Ads Shown")
ylabel("Regret")
legend(string(epsilons))
hold off
%% average regret over 10 experiments of 1000 trials and plot egreedy
regrets_greedy = [];
regrets_decreasing = [];
x = 1:100;
for i = x
    e_Greedy = eGreedy_run;
    e_Greedy.run
    regrets_greedy(i,:) = e_Greedy.regret;

    e_Decrease = eDecrease_run;
    e_Decrease.run
    regrets_decreasing(i,:) = e_Decrease.regret;
end

plot_areaerrorbar(regrets_greedy)

%% plot edecreasing

plot_areaerrorbar(regrets_decreasing)
