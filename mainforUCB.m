% run eGreedy model + plots
ucb = UCB_run;
ucb.n_trials = 2000;
ucb.run


figure
hold on
x = 1:ucb.n_trials;
            
for i = 1:ucb.ad_Campaigns.N
    plot(x, [ucb.myUCB.scores(:,i)]', 'LineWidth',2);
    xlabel('Number of Trials'); ylabel('Estimated CTR'); 
    title('Upper Confidence Bound strategy for Ad Campaigns');
            end
legend(["Ad1", "Ad2", "Ad3"])
hold off

figure 
plot(1:ucb.n_trials - 1, ucb.regret)
xlabel("Trial")
ylabel("Regret")
title("Regret over 1000 trials")

%% average regret over 10 experiments of 1000 trials and plot egreedy
regrets_ucb = [];
%regrets_decreasing = [];
x = 1:50;
for i = x
    ucb = UCB_run;
    ucb.run
    regrets_ucb(end+1) = ucb.regret(end);

    %e_Decrease = eDecrease_run;
    %e_Decrease.run
    %regrets_decreasing(end+1) = e_Decrease.regret(end);
    i
end

scatter(1, mean(regrets_ucb))
%% plot edecreasing

% plot_areaerrorbar(regrets_decreasing)