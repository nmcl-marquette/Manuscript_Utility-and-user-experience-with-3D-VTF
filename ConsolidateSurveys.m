%% ConsolidateSurveys.m
% This code interates through all participants's survey .xlsx files 
% and consolidates them into a .mat and .xlsx file
%
% Variables:
%   subIDs          String of the participant IDs
% 
% Output:
%   SurveyScores    Creates a .mat and .xlsx file of consolidated survey data

subIDs = {'ID_001','ID_002'};

root = [pwd '/'];
dataDir = [root 'SurveyResponses/'];
saveDir = root;
subNum = length(subIDs);
index = 1;

subID = cell(subNum,1);
susA = NaN(subNum,1);
intrst = NaN(subNum,1);
effort = NaN(subNum,1);
value = NaN(subNum,1);
comptn = NaN(subNum,1);
prssur = NaN(subNum,1);
choice = NaN(subNum,1);
questS = NaN(subNum,7);
quest1 = cell(subNum,1);
quest2 = cell(subNum,1);
quest3 = cell(subNum,1);

for s = 1:length(subIDs)
    sID = subIDs{s};
    fileName = [dataDir sID '_Survey.xlsx'];
    disp(['    Evaluating ' sID])

    if ~exist(fileName, 'file')
        disp('    NO SURVEY')

        subID{index} = sID;
        susA(index) = NaN;
        intrst(index) = NaN;
        effort(index) = NaN;
        value(index) = NaN;
        comptn(index) = NaN;
        prssur(index) = NaN;
        choice(index) = NaN;
        questS(index,:) = [NaN NaN NaN ...
            NaN NaN NaN NaN];
        quest1{index} = NaN;
        quest2{index} = NaN;
        quest3{index} = NaN;
    else
        sus = readtable(fileName, 'Sheet','sus',...
            'Range','A1:B10','ReadVariableNames',false);
        sus = renamevars(sus,'Var1','Statement');
        sus = renamevars(sus,'Var2','Score');
        Survey.sus = sus;
    
        imi = readtable(fileName, 'Sheet','imi',...
            'ReadVariableNames',false);
        imi = renamevars(imi,'Var1','Statement');
        imi = renamevars(imi,'Var2','Score');
        Survey.imi = imi;
    
        quest = readtable(fileName, 'Sheet','quest',...
            'Range','A1:C9','ReadVariableNames',false);
        quest = renamevars(quest,'Var1','Statement');
        quest = renamevars(quest,'Var2','Score');
        quest = renamevars(quest,'Var3','Comments');
    
        imi_intrst = ((8-imi{2,2})+imi{12,2}+imi{19,2}+imi{21,2}+(8-imi{23,2})+imi{29,2}+imi{31,2})/7;
        imi_effort = (imi{5,2}+imi{8,2}+(8-imi{25,2})+(8-imi{27,2})+imi{36,2})/5;
        imi_value  = (imi{3,2}+imi{13,2}+imi{24,2}+imi{26,2}+imi{30,2}+imi{33,2}+imi{37,2})/7;
        imi_comptn = (imi{1,2}+imi{6,2}+imi{7,2}+imi{9,2}+(8-imi{11,2})+imi{17,2}+(8-imi{30,2}))/6;
        imi_prssur = ((8-imi{10,2})+imi{14,2}+imi{20,2}+(8-imi{32,2})+imi{34,2})/5;
        imi_choice = ((8-imi{4,2})+(8-imi{15,2})+imi{16,2}+(8-imi{18,2})+imi{22,2}+(8-imi{28,2})+(8-imi{35,2}))/7;
        quest_avg  = mean(quest{1:6,2});
        quest_itm  = quest{7:9,3};
        sus_avg    = ((sus{1,2}-1)+(5-sus{2,2})+(sus{3,2}-1)+(5-sus{4,2})+(sus{5,2}-1)+(5-sus{6,2})+(sus{7,2}-1)+(5-sus{8,2})+(sus{9,2}-1)+(5-sus{10,2}))*2.5;

        subID{index} = sID;
        susA(index) = sus_avg;
        intrst(index) = imi_intrst;
        effort(index) = imi_effort;
        value(index) = imi_value;
        comptn(index) = imi_comptn;
        prssur(index) = imi_prssur;
        choice(index) = imi_choice;
        questS(index,:) = [quest{1,2} quest{2,2} quest{3,2} ...
            quest{4,2} quest{5,2} quest{6,2} quest_avg];
        quest1{index} = quest_itm{1};
        quest2{index} = quest_itm{2};
        quest3{index} = quest_itm{3};
    end

    index = index + 1;
end

SurveyScores.SubID = string(subID);
SurveyScores.SusAvg = susA;
SurveyScores.ImiInterest = intrst;
SurveyScores.ImiEffort = effort;
SurveyScores.ImiValue = value;
SurveyScores.ImiCompetence = comptn;
SurveyScores.ImiPressure = prssur;
SurveyScores.ImiChoice = choice;
SurveyScores.QuestWeight = questS(:,1);
SurveyScores.QuestSafety = questS(:,2);
SurveyScores.QuestEase = questS(:,3);
SurveyScores.QuestComfort = questS(:,4);
SurveyScores.QuestEffect = questS(:,5);
SurveyScores.QuestService = questS(:,6);
SurveyScores.QuestAvg = questS(:,7);
SurveyScores.qItem1 = string(quest1);
SurveyScores.qItem2 = string(quest2);
SurveyScores.qItem3 = string(quest3);

SurveyTable = struct2table(SurveyScores);
filename = [saveDir 'SurveyScores.xlsx'];
writetable(SurveyTable,filename,'Sheet','Sheet1','WriteMode','overwritesheet')

save([saveDir 'SurveyScores'], 'SurveyTable', 'SurveyScores');