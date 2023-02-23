% run eGreedy model + CTR plot + table final values
e_Greedy = eGreedy_run;
e_Greedy.n_trials = 1000;
e_Greedy.run


figure
hold on
x = 1:e_Greedy.n_trials;
            
for i = 1:e_Greedy.ad_Campaigns.N
    plot(x, [e_Greedy.myGreedy.scores(:,i)]', 'LineWidth',2);
    xlabel('Number of Trials'); ylabel('Estimated CTR');
end
legend(["Ad1", "Ad2", "Ad3"])
hold off

estimated_ctr = array2table([e_Greedy.myGreedy.scores(end,:)], "VariableNames", ["Ad1","Ad2","Ad3"])
%% run eDecaying model + CTR plot + table final values
e_Decay = eDecrease_run;
e_Decay.n_trials = 1000;
e_Decay.run


figure
hold on
x = 1:e_Decay.n_trials;
            
for i = 1:e_Decay.ad_Campaigns.N
    plot(x, [e_Decay.myGreedy.scores(:,i)]', 'LineWidth',2);
    xlabel('Number of Trials'); ylabel('Estimated CTR');
end
legend(["Ad1", "Ad2", "Ad3"])
hold off

estimated_ctr = array2table([e_Decay.myGreedy.scores(end,:)], "VariableNames", ["Ad1","Ad2","Ad3"])

%% run UCB model + CTR plot + table final values
ucb = UCB_run;
ucb.n_trials = 1000;
ucb.run


figure
hold on
x = 1:ucb.n_trials;
            
for i = 1:ucb.ad_Campaigns.N
    plot(x, [ucb.myUCB.scores(:,i)]', 'LineWidth',2)
    xlabel('Number of Trials'); ylabel('Estimated CTR');
end
legend(["Ad1", "Ad2", "Ad3"])
hold off

estimated_ctr = array2table([ucb.myUCB.scores(end,:)], "VariableNames", ["Ad1","Ad2","Ad3"])

%% plots regret for different values of epsilon for epsilon-Greedy strategy
epsilons = 0:0.1:0.5;
iterations = 1:100;
n_trials = 100;
n_ads = 3:4:20;
regrets_end = [];
for n = n_ads
    figure
    hold on
    for e = epsilons
        regrets = [];
        
        for i = iterations
            e_Greedy = eGreedy_run;
            e_Greedy.ad_Campaigns = ad_Bandit(rand(1,length(n_ads)));
            e_Greedy.myGreedy = eGreedy(length(n_ads),e);
            e_Greedy.n_trials = n_trials;
            e_Greedy.run
            regrets(i,:) = e_Greedy.regret;
        end
        e
        mean_regrets = mean(regrets);
        plot(mean_regrets)
        regrets_end(end+1) = mean_regrets(end);
    end
    xlabel("#Ads Shown")
    ylabel("Regret")
    title("")
    legend(string(epsilons))
    hold off
    n
end

figure
data = reshape(regrets_end,[length(epsilons), length(n_ads)]);
bar(n_ads,transpose(data));
xlabel("Number of Ads in Campaign")
ylabel("Regret after " + string(n_trials) + " trials")
lgd = legend([string(epsilons)]);
lgd.Title.String = "Value of \epsilon";

%% plots regret for different epsilon functions for epsilon decaying
exps = 1:3;
iterations = 1:100;
n_trials = 100;
n_ads = 3:7;
regrets_end = [];
for n = n_ads
    figure
    hold on
    for exp = exps
        epsilon_func = @(i) 1/(i.^exp);
        regrets = [];
        
        for i = iterations
            e_Decay = eDecrease_run;
            e_Decay.ad_Campaigns = ad_Bandit(rand(1,length(n_ads)));
            e_Decay.myGreedy = eGreedy(length(n_ads),0);
            e_Decay.n_trials = n_trials;
            e_Decay.e_func = epsilon_func;
            e_Decay.run
            regrets(i,:) = e_Decay.regret;
        end
        exp
        mean_regrets = mean(regrets);
        plot(mean_regrets)
        regrets_end(end+1) = mean_regrets(end);
    end
    xlabel("#Ads Shown")
    ylabel("Regret")
    title("")
    legend(string(exps))
    hold off
    n
end

figure
data = reshape(regrets_end,[length(exps), length(n_ads)]);
bar(n_ads,transpose(data));
xlabel("Number of Ads in Campaign")
ylabel("Average Regret after " + string(n_trials) + " trials")
lgd = legend([string(exps)]);
lgd.Title.String = "Value of exponential";



%% average regret over x experiments of n trials and plot egreedy
regrets_greedy = [];
regrets_decreasing = [];
regrets_ucb = [];
x = 1:5;
n = 1000;
for i = x
    e_Greedy = eGreedy_run;
    e_Greedy.n_trials = n;
    e_Greedy.ad_Campaigns = ad_Bandit([0.28,0.35,0.4]);
    e_Greedy.run
    regrets_greedy(end+1) = e_Greedy.regret(end);

    e_Decrease = eDecrease_run;
    e_Decrease.n_trials = n;
    e_Decrease.run
    regrets_decreasing(end+1) = e_Decrease.regret(end);

    ucb = UCB_run;
    ucb.n_trials = n;
    ucb.run
    regrets_ucb(end+1) = ucb.regret(end);
    i
end

strats = categorical({'\epsilon -Greedy', ' \epsilon -Decreasing', 'UCB'});
strats = reordercats(strats,{'\epsilon -Greedy', ' \epsilon -Decreasing', 'UCB'});

bar(strats, [mean(regrets_greedy), mean(regrets_decreasing), mean(regrets_ucb)])
figure
bar(strats, [std(regrets_greedy), std(regrets_decreasing), std(regrets_ucb)])


