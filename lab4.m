close all
clear all
clc
%% raidþiø pavyzdþiø nuskaitymas ir poþymiø skaièiavimas
%% read the image with hand-written characters
pavadinimas = 'NUM2.jpg';

N = 4;
pattern = 9;
pozymiai_tinklo_mokymui = pozymiai_atpazinti(pavadinimas, N,0);

%% Atpaþintuvo kûrimas
%% Development of character recognizer
% poþymiai ið celiø masyvo perkeliami á matricà
% take the features from cell-type variable and save into a matrix-type variable
P = cell2mat(pozymiai_tinklo_mokymui);

% sukuriama teisingø atsakymø matrica: 11 raidþiø, 8 eilutës mokymui
% create the matrices of correct answers for each line (number of matrices = number of symbol lines)
% T = [eye(pattern), eye(pattern), eye(pattern), eye(pattern), eye(pattern), eye(pattern), eye(pattern), eye(pattern), eye(pattern)];
T = [ ];
for i = 1 : N
    T = [T eye(pattern)];
end
T;
% T = [eye(pattern), eye(pattern), eye(pattern), eye(pattern)];
% sukuriamas SBF tinklas duotiems P ir T sàryðiams

% Choose neural network, 0 - RBF , other multi percepton neural net
net = 1

if net == 0
    % create an RBF network for classification with 13 neurons, and sigma = 1
    RBF = newrb(P,T,0,1,13);
    tinklas = RBF;
else
    % create an multilayer perceptron for classification with 10 neurons
    MULTI_PERCEPTON = feedforwardnet(10);
    MULTI_PERCEPTON = train(MULTI_PERCEPTON,P,T);
    tinklas = MULTI_PERCEPTON;
end

% -- TEST OUR NEURAL NETWORK --
disp(" ");
image_array = [ "TEST1.jpg" , "TEST2.jpg" , "TEST3.jpg" , "TEST4.jpg","TEST5.jpg","TEST6.jpg","TEST7.jpg","TEST8.jpg", "TEST9.jpg", "TEST10.jpg", "TEST11.jpg" ];
image_values = ["1236","2","15","1236","123","89","1","1","12345","6789","123456789"];
autotest(tinklas,image_array,image_values)



%% Pasirinktas testavimas 
%% Extract features of the test image
pavadinimas = 'TEST3.jpg';
pozymiai_patikrai = pozymiai_atpazinti(pavadinimas, 1,0);

%% Raidþiø atpaþinimas
%% Perform letter/symbol recognition
% poþymiai ið celiø masyvo perkeliami á matricà
% features from cell-variable are stored to matrix-variable
P2 = cell2mat(pozymiai_patikrai);
% skaièiuojamas tinklo iðëjimas neþinomiems poþymiams
% estimating neuran network output for newly estimated features
Y2 = sim(tinklas, P2);
% ieðkoma, kuriame iðëjime gauta didþiausia reikðmë
% searching which output gives maximum value
[a2, b2] = max(Y2);
%% Rezultato atvaizdavimas | Visualization of result
% apskaièiuosime raidþiø skaièiø - poþymiø P2 stulpeliø skaièiø
% calculating number of symbols - number of columns
raidziu_sk = size(P2,2);
% rezultatà saugosime kintamajame 'atsakymas'
atsakymas = [];
for k = 1:raidziu_sk
    switch b2(k)
        case 1
            % the symbol here should be the same as written first symbol in your image
            atsakymas = [atsakymas, '1'];
        case 2
            atsakymas = [atsakymas, '2'];
        case 3
            atsakymas = [atsakymas, '3'];
        case 4
            atsakymas = [atsakymas, '4'];
        case 5
            atsakymas = [atsakymas, '5'];
        case 6
            atsakymas = [atsakymas, '6'];
        case 7
            atsakymas = [atsakymas, '7'];
        case 8
            atsakymas = [atsakymas, '8'];
        case 9
            atsakymas = [atsakymas, '9'];
    end
end
% pateikime rezultatà komandiniame lange
% disp(atsakymas)
figure(8), text(0.1,0.5,atsakymas,'FontSize',38), axis off




function autotest(tinklas,test_image_array,test_image_number)

disp("--STARTING AUTO-TESTING-- ")

predicted_numbers =  [] ;

test_size = size(test_image_array,2)
if test_size ~= size(test_image_number,2)
    disp("WRONG SIZE !! STOP TESTING, IMAGE ARRAY SHOULD BE MATCHED WITH IMAGE NUMBER")    
end

for i = 1 : test_size
    
    
    pavadinimas = test_image_array(i);
    passed = 0;
    pozymiai_patikrai = pozymiai_atpazinti(pavadinimas, 1,0);

    P2 = cell2mat(pozymiai_patikrai);
    
    Y2 = sim(tinklas, P2);
    
    [a2, b2] = max(Y2);
    
    raidziu_sk = size(P2,2);
    
    atsakymas = [];
    for k = 1:raidziu_sk
        switch b2(k)
            case 1
                % the symbol here should be the same as written first symbol in your image
                atsakymas = [atsakymas, '1'];
            case 2
                atsakymas = [atsakymas, '2'];
            case 3
                atsakymas = [atsakymas, '3'];
            case 4
                atsakymas = [atsakymas, '4'];
            case 5
                atsakymas = [atsakymas, '5'];
            case 6
                atsakymas = [atsakymas, '6'];
            case 7
                atsakymas = [atsakymas, '7'];
            case 8
                atsakymas = [atsakymas, '8'];
            case 9
                atsakymas = [atsakymas, '9'];
        end
    end
    predicted_numbers{i} = atsakymas;
end

% Now we compare our predicted numbers with real ones
for i = 1 : test_size
   
   predicted = str2num(convertCharsToStrings(predicted_numbers(i)));
   realnumber = str2num(test_image_number(i));
   
   if predicted == realnumber
       disp("Y | Test passed : System predicted " + predicted + " and real number is " + realnumber)
       passed = passed + 1;
   else
       disp("X | Test failed : System predicted " + predicted + " and real number is " + realnumber)
   end
end

disp("Total passed tests : " + passed + "/" + test_size)

disp("--END OF AUTO-TESTING-- ");
disp(" ");
end