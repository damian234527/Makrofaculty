#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <Windows.h>
#pragma warning(disable : 4996)    // disable warning that fopen is dangerous etc.

int anc(char anf[]);	// function to check if account number is correct anf - account number in function
int aec(char anf2[], int teone);	//function to check if account exist teone - to exist or not exist (if account should or shouldn't exist)
int admm(int admc);
// Bank management system – a program should keep track of any transactions at given bank account, send money between accounts and deposit and withdraw money.

int main()
{
	int num, adm = 0, pass = 1234, gpass, am, size;
	double aom=0, aomf1, aomf2;
	char an[6], ana[6], ao[51],ao2[51], fn[11], fn2[11],t[51];
	char* log=NULL;
	// num - chosen number adm - admin mode pass - password gpass - given password am - mode of account operations (1-add,2-delete,3-merge etc.)  size - size of file  i - iteration
	// aom - amount of money  aomf - amount of money in file  
	// an - account number ana - auxiliary account number ao - account owner fn - file name t - temporal
	// log - future array that will display logs
	
	FILE* fpl = fopen("logs.txt", "a+");    // checks if logs.txt exists and opens it 
	time_t date = time(0); // sets time variable for logs and notes
	fprintf(fpl,"%s", asctime(localtime(&date)));
	fprintf(fpl, "  Launch of banking system\n\n");
	fclose(fpl);

	FILE* fpn = fopen("notes.txt", "a+"); // checks if notes.txt exists
	fclose(fpn);

menu:
	Beep(900, 100);  // sound effect to inform you are in menu
	if (adm == 1)
	{
		printf("Admin mode enabled!\n");
	}
	printf("Welcome to Koscielny's Banking System\n\n");
	printf("Please, select what operation you want to perform by entering its number: \n");
	printf("  1.Create new account or delete the old one.\n  2.Edit data about existing account.\n  3.Check account details.\n  4.Deposit, withdraw money or make a cash transfer.\n  5.Check log of transfers.\n  6.Check or add notes.\n  7.Enable admin mode.\n  0.Quit\n");
	scanf_s("%d", &num);
	if (num < 0 || num > 8)
	{
		while ((getchar()) != '\n');
		
	}
	system("cls");  //clears console


	switch (num)
	{
		
	case 1:
	acc:
		num = 5;
		printf("You have chosen to create or delete an account\n\n");
		printf("Select next operation: \n");
		printf("  1.Create new account.\n  2.Delete existing account.\n  3.Merge two accounts.\n  0.Go back.\n");
		scanf_s(" %d", &num);	
		if (num < 0 || num>3)
		{
			while ((getchar()) != '\n');
			system("cls");
		}
		


		switch (num)
		{
		case 1:
		account_creation:

			printf("You have chosen to create a new account\n  Type account number that consists of 6 digits: ");  
			scanf("%6s", &an);
			if (anc(an) == 1 || aec(an, 0) == 0) goto account_creation;
			while ((getchar()) != '\n');    //clear buffer in case of more than 6 digits
		account_creation2:
			printf("Type owner's name of the account number, use '_' or '-' instead of space (max length is 50 characters): ");
			scanf("%51s", &ao);
			if (ao[50] != 0)
			{
				printf("Owner's name is too long.");
				Sleep(1000);
				system("cls");
				while ((getchar()) != '\n');
				goto account_creation2;
			}
			am = 1;
			goto account_files;
		case 2:
			account_deletion:
			printf("You have chosen to delete existing account\n  Type account number that consists of 6 digits: ");
			scanf("%6s", &an);
			if (anc(an) == 1 || aec(an, 1) == 1) goto account_deletion;
			am = 2;
			goto account_files;
		case 3:
			account_merge1:
			printf("You have chosen to merge two accounts 3\n  Type account number that consists of 6 digits and will remain: ");
			scanf("%6s", &an);
			while ((getchar()) != '\n');
			if (anc(an) == 1 || aec(an,1)==1) goto account_merge1;
			account_merge2:
			printf("\n  Type account number that consists of 6 digits and will be absorbed: ");
			scanf("%6s", &ana);
			if (anc(ana) == 1 || aec(ana, 1) == 1) goto account_merge2;
			am = 3;
			goto account_files;
		case 0:
			system("cls");
			goto menu;
		default:
			printf("Wrong digit, try again");
			Sleep(1000);
			system("cls");
			goto acc;
		}

	case 2:
	edit:
		num = 5;
		printf("You have chosen to edit data about existing account\n\n");
		if (admm(adm) != 1) goto menu;
		printf("Select next operation: \n");
		printf("  1.Change account number.\n  2.Change account owner.\n  3.Manually change account balance.\n  0.Go back.\n");
		scanf_s("%d", &num);
		if (num < 0 || num>3)
		{
			while ((getchar()) != '\n');
		}
		system("cls");
		switch (num)
		{
		case 1:
			ch_acc_num1:
			printf("You have chosen to change account number\n  Type current account number: ");
			scanf("%6s", &ana);
			while ((getchar()) != '\n');
			if (anc(an) == 1 || aec(an, 1) == 1) goto ch_acc_num1;
			ch_acc_num2:
			printf("\n  Type new account number: ");
			scanf("%6s", &an);
			if (anc(an) == 1 || aec(an, 0) == 0) goto ch_acc_num2;
			am = 4;
			goto account_files;

		case 2:
			ch_acc_o:
			printf("You have chosen to change account owner\n  Type current account number: ");
			scanf("%6s", &an);
			while ((getchar()) != '\n');
			if (anc(an) == 1 || aec(an, 1) == 1) goto ch_acc_o;
		ch_acc_o2:
			printf("\n  Specify new account owner: ");
			scanf("%51s", &ao);
			if (ao[50] != 0)
			{
				printf("Owner's name is too long.");
				Sleep(1000);
				system("cls");
				while ((getchar()) != '\n');
				goto ch_acc_o2:;
			}
			am = 5;
			num = 1;
			goto account_files;

		case 3:
			ch_acc_bal:
			printf("You have chosen to change account balance manually\n");
			printf("  Type account number: ");
			scanf("%6s", &an);
			while ((getchar()) != '\n');
			if (anc(an) == 1 || aec(an, 1) == 1) goto ch_acc_bal;
			printf("\n  Specify new account balance: ");
			scanf("%lf", &aom);
			am = 5;
			num = 2;
			goto account_files;


		case 0:
			system("cls");
			goto menu;
		default:
			printf("Wrong digit, try again");
			Sleep(1000);
			system("cls");
			goto edit;
		}

		break;
	case 3:
	details:
		num = 5;
		printf("You have chosen check account details \n\n");
		printf("Select next operation: \n");
		printf("  1.Check account existence.\n  2.Check account balance.\n  3.Check account owner.\n  4.Check account details.\n  0.Go back.\n");
		scanf_s("%d", &num);
		if (num < 0 || num>4)
		{
			while ((getchar()) != '\n');
		}
		system("cls");
		switch (num)
		{
		case 1:
			abc:
			printf("You have chosen to check account existence\n  Type account number: ");
			scanf("%6s", &an);
			if (anc(an) == 1) goto abc;
			am = 7;
			num = 0;
			goto account_files;
		case 2:
			ae:
			printf("You have chosen to check account balance\n  Type account number: ");
			scanf("%6s", &an);
			if (anc(an) == 1 || aec(an, 1) == 1) goto ae;
			am = 7;
			num= 2;
			goto account_files;

		case 3:
			aoc:
			printf("You have chosen to check account owner\n  Type account number: ");
			scanf("%6s", &an);
			if (anc(an) == 1 || aec(an, 1) == 1) goto aoc;
			am = 7;
			num = 1;
			goto account_files;
		case 4:
			ad:
			printf("You have chosen to check account details\n  Type account number: ");
			scanf("%6s", &an);
			if (anc(an) == 1 || aec(an, 1) == 1) goto ad;
			am = 7;
			num = 3;
			goto account_files;
		case 0:
			system("cls");
			goto menu;
		default:
			printf("Wrong digit, try again");
			Sleep(1000);
			system("cls");
			goto details;
		}
		

		break;
	case 4:
		transfer:
		printf("You have chosen to make a cash transfer\n\n");
		printf("Select next operation: \n");
		printf("  1.Deposit money.\n  2.Withdraw money.\n  3.Transfer money to another account.\n  0.Go back.\n");
		scanf_s("%d", &num);
		if (num < 0 || num>3)
		{
			while ((getchar()) != '\n');
		}
		system("cls");
		switch (num)
		{
		case 1:
			deposit:
			printf("You have chosen to deposit money\n  Type account number: ");
			scanf("%6s", &an);
			while ((getchar()) != '\n');
			if (anc(an) == 1 || aec(an, 1) == 1) goto deposit;
			d2:
			printf("\n  Type amount of money you want to deposit: ");
			scanf("%lf", &aom);
			if (aom < 0)
			{
				printf("Wrong value");
				Sleep(1000);
				system("cls");
				goto d2;
			}
			am = 6;
			num = 1;
			goto account_files;
		case 2:
		withdraw:
			printf("You have chosen to withdraw money\n  Type account number: ");
			scanf("%6s", &an);
			while ((getchar()) != '\n');
			if (anc(an) == 1 || aec(an, 1) == 1) goto withdraw;
			w2:
			printf("\n  Type amount of money you want to withdraw: ");
			scanf("%lf", &aom);
			if (aom < 0)
			{
				printf("Wrong value");
				Sleep(1000);
				system("cls");
				goto w2;
			}
			am = 6;
			num = 2;
			goto account_files;
		case 3:
			transfer1:
			printf("You have chosen to transfer money\n  Type account number of sender : ");
			scanf("%6s", &an);	
			while ((getchar()) != '\n');
			if (anc(an) == 1 || aec(an, 1) == 1) goto transfer1;
			transfer2:
			printf("  Type account number of recipient: ");
			scanf("%6s", &ana);
			while ((getchar()) != '\n');
			if (anc(an) == 1 || aec(an, 1) == 1) goto transfer2;
			transfer3:
			printf("  Type amount of money you want to transfer: ");
			scanf("%lf", &aom);
			if (aom < 0)
			{
				printf("Wrong value");
				Sleep(1000);
				system("cls");
				goto transfer3;
			}
			am = 8;
			goto account_files;
		case 0:
			system("cls");
			goto menu;
		default:
			printf("Wrong digit, try again");
			Sleep(1000);
			system("cls");
			goto transfer;
		}

	case 5:
		logs:
		printf("You have chosen to check logs \n\n");
		if (admm(adm) != 1) goto menu;
		FILE* fpl = fopen("logs.txt", "r");
		fseek(fpl, 0L, SEEK_END);      //set on last position
		size = ftell(fpl);				//chceck current position
		fseek(fpl, 0L, SEEK_SET);		//set on first position
		log = (char*)calloc(size, sizeof(char));   //allocate and initialize an array to store file content
		fread(log, sizeof(char), size, fpl);		//read from file and assign to log array
		fclose(fpl);								
		printf("%s", log);
		free(log);
		printf("Select next operation: \n");
		printf("  1.Delete logs.\n  0.Go back.\n");
		scanf("%d", &num);
		if (num < 0 || num>1)
		{
			while ((getchar()) != '\n');
		}
		system("cls");
		switch (num)
		{
		case 1:
		{
			FILE* fpl = fopen("logs.txt", "w");
			fclose(fpl);
		}
		case 0:
			system("cls");
			goto menu;
		default:
			printf("Invalid character");
			Sleep(1000);
			system("cls");
			goto logs;

		}

		break;
	case 6:
		notes:
		printf("You have chosen to check notes \n\n");
		
		FILE *fpn=fopen("notes.txt","r");
		fseek(fpn, 0, SEEK_END);
		size = ftell(fpn);
		fseek(fpn, 0, SEEK_SET);
		log = (char*)calloc(size, sizeof(char));
		fread(log, sizeof(char), size, fpn);
		fclose(fpn);
		printf("\n %s \n", log);
		free(log);

		printf("Select next operation: \n");
		printf("  1.Add note.\n  2.Create a blank note file.\n  0.Go back.\n");
		scanf("%d", &num);
		if (num < 0 || num>2)
		{
			while ((getchar()) != '\n');
		}
		system("cls");
		switch (num)
		{
		case 1:
		{
			FILE* fp = fopen("notes.txt", "a");
			time_t date = time(0);
			fprintf(fp,"Notes from %s", asctime(localtime(&date)));  // gives time the notes come from
			fclose(fp);
			while ((getchar()) != '\n');
			FILE* fp2 = fopen("notes.txt", "a");
			printf("  Type your note: ");
			gets(ao);
			fputs(ao, fp2);
			fprintf(fp2, "\n\n");
			fclose(fp2);
			system("cls");
			goto notes;
		}
		case 2:
		{
			FILE* fp = fopen("notes.txt", "w");
			printf("Operation completed");
			Sleep(1000);
			system("cls");
			fclose(fp);
		}
		case 0:
			system("cls");
			goto menu;
		default:
			printf("Wrong digit, try again");
			Sleep(1000);
			system("cls");
			goto notes;
		}
		break;
	case 7:
		if (adm == 1)
		{
			printf("Admin mode already active");
			Sleep(1000);
			system("cls");
			goto menu;
		}
		printf("Enter the password:\t");
		scanf_s("%d", &gpass);    //given password
		system("cls");
		if (gpass == pass)
		{
			adm = 1;
			printf("Correct password.\n\n");
		}
		else
		{
			printf("Incorrect password\n");

		}
		Sleep(1000);
		system("cls");
		goto menu;
	case 0:
		printf("Shutting down");
		Sleep(1000);
		exit(0);
	default:
		printf("Wrong digit, try again");
		Sleep(1000);
		system("cls");
		goto menu;

	}	
account_files:
	{

	while ((getchar()) != '\n');
		switch (am)
		{
		case 1:	 //create
		{

			//fn - filename
			sprintf(fn, "%s.txt", an);  //adds .txt in order to create a text file.
			FILE* fp = fopen(fn, "w");  //afp - account file pointer
			fprintf(fp, "%s\n  Balance: %.2f", ao);		// fill account file
			fclose(fp);
			FILE* fpl = fopen("logs.txt", "a");
			time_t date = time(0);
			fprintf(fpl, "%s", asctime(localtime(&date)));
			fprintf(fpl, "  Acc %s created\n\n", an);
			fclose(fpl);
			printf("Operation compeleted");
			Sleep(1000);
			system("cls");
			goto menu;

		}
		case 2: //delete
		{
			sprintf(fn, "%s.txt", an);
			remove("last_deleted.txt");
			rename(fn, "last_deleted.txt");
			FILE* fp = fopen(fn, "r");
			if (fp != NULL)
			{
				fclose(fp);
				printf("Something went wrong, try again later");
				Sleep(1000);
				system("cls");
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s deletion unsuccessful\n\n", an);
				fclose(fpl);
				goto menu;
			}
			printf("Operation compeleted");
			Sleep(1000);
			system("cls");
			FILE* fpl = fopen("logs.txt", "a");
			time_t date = time(0);
			fprintf(fpl, "%s", asctime(localtime(&date)));
			fprintf(fpl, "  Acc %s deleted\n\n", an);
			fclose(fpl);
			goto menu;


		}
		case 3: //merge   fms - file merge string  fmn - file merge name  f1m - file 1 money  fma - file money all  fm1 - file merge 1  fmf - file merge final
		{
			sprintf(fn, "%s.txt", an);
			sprintf(fn2, "%s.txt", ana);
			remove("last_merged.txt");
			FILE* fp = fopen(fn, "r");
			fscanf(fp, "%s %s %lf", &ao, &t, &aomf1);
			fclose(fp);
			FILE* fp2 = fopen(fn2, "r");
			fscanf(fp2, "%s %s %lf", &t, &t, &aomf2);
			fclose(fp2);
			aom = aomf1 + aomf2;
			rename(fn2, "last_merged.txt");
			FILE* fp3 = fopen(fn2, "r");
			if (fp3 != NULL)
			{
				fclose(fp3);
				printf("Something went wrong, try again later");
				Sleep(1000);
				system("cls");
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s and %s merged unsuccessfully\n\n",an, ana);
				fclose(fpl);
				goto menu;
			}
			FILE* fpl = fopen("logs.txt", "a");
			time_t date = time(0);
			fprintf(fpl, "%s", asctime(localtime(&date)));
			fprintf(fpl, "  Acc %s merged into %s\n\n", ana, an);
			fclose(fpl);
			FILE* fpnew = fopen(fn, "w");
			fprintf(fpnew, "%s\n  Balance: %.2f", ao, aom);
			fclose(fpnew);
			printf("Operation compeleted");
			Sleep(1000);
				goto menu;

		}
		case 4: // change number
		{
			char old[11], new[11];
			sprintf(old, "%s.txt", ana);
			sprintf(new, "%s.txt", an);
			rename(old, new);
			FILE* fpl = fopen("logs.txt", "a");
			time_t date = time(0);
			fprintf(fpl, "%s", asctime(localtime(&date)));
			fprintf(fpl, "  Acc %s renamed to %s\n\n", old, new);
			fclose(fpl);
			printf("Operation completed");
			Sleep(1000);
			system("cls");
			goto menu;
		}
		case 5: // change owner & balance
		{
			sprintf(fn, "%s.txt", an);
			FILE* fp = fopen(fn, "r");
			if(num==1)
			{
				fscanf(fp, "%s %s %lf", &ao2, &t, &aom);
				fclose(fp);
				FILE* fp2 = fopen(fn, "w");
				fprintf(fp2, "%s\n  Balance: %.2f", ao, aom);
				fclose(fp2);
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s changed ownership from %s to %s\n\n ", an, ao2, ao);
				fclose(fpl);
			}
			if (num == 2)
			{
				fscanf(fp, "%s %s %lf", &ao, &t, &aomf1);
				fclose(fp);
				FILE* fp2 = fopen(fn, "w");
				fprintf(fp2, "%s\n  Balance: %.2f", ao, aom);
				fclose(fp2);
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s changed balance from %.2f to %.2f\n\n", an, aomf1, aom);
				fclose(fpl);
			}
			printf("Operation completed");
			Sleep(1000);
			system("cls");
			goto menu;
		}
		case 6: // deposit or withdraw money
		{	
			
			double oaom, naom; //oaom - old amount of money  naom - new amount of money
			sprintf(fn, "%s.txt", an);
			FILE* fp = fopen(fn, "r");
			fscanf(fp, "%s %s %lf", &ao, &t, &oaom);
			fclose(fp);
			if (num == 1)
			{
				naom = oaom + aom;
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s deposited %.2f, balance is %.2f\n\n ", an, aom, naom);
				fclose(fpl);
			}
			if (num == 2)
			{
				naom = oaom - aom;
				if (naom < 0)
				{
					FILE* fpl = fopen("logs.txt", "a");
					time_t date = time(0);
					fprintf(fpl, "%s", asctime(localtime(&date)));
					fprintf(fpl, "  Acc %s tried to withdrew %.2f, balance is %.2f\n\n ", an, aom, oaom);
					fclose(fpl);
					printf("You don't have enough money");
					Sleep(2000);
					system("cls");
					goto menu;
				}
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s withdrew %.2f, balance is %.2f\n\n ", an, aom, naom);
				fclose(fpl);
			}
			FILE* fp2 = fopen(fn, "w");
			fprintf(fp2, "%s\n  Balance: %.2f", ao, naom);
			fclose(fp2);
			if (naom == oaom)
			{
				printf("Something went wrong, account balance is %.2f", naom);
				Sleep(2000);
				system("cls");
				goto menu;
			}
			printf("Operation completed, new account balance is %.2f",naom);
			Sleep(2000);
			system("cls");
			goto menu;
		}
		case 7: // check account existence, balance and owner DONE 
		{
			sprintf(fn, "%s.txt", an);
			FILE* fp = fopen(fn, "r");
			if (fp == (NULL))
			{
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s checked existence, does not exist\n\n ", an);
				fclose(fpl);
				printf("Given account does not exist");
				Sleep(1000);
				system("cls");
				goto menu;
			}
			fscanf(fp, "%s %s %lf",&ao, &t, &aom);
			fclose(fp);
			if (num == 0)
			{
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s checked existence, exists\n\n ", an);
				fclose(fpl);
				printf("Account exists");
			}
			if (num == 1 || num == 3)printf("Name: %s\n", ao);
			if (num == 2 || num == 3)printf("Balance: %.2f", aom);
			if (num == 1)
			{
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s checked ownership: %s\n\n ", an, ao);
				fclose(fpl);
			}
			if (num == 2)
			{
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s checked balance: %.2f\n\n ", an, aom);
				fclose(fpl);
			}
			if (num == 3)
			{
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s checked owner and balance: %s %.2f\n\n ", an, ao, aom);
				fclose(fpl);
			}
			Sleep(2000);
			system("cls");
			goto menu;

		}
		case 8: // transfer
		{
			double b1, b2; // balance
			sprintf(fn, "%s.txt", an);
			sprintf(fn2, "%s.txt", ana);
			FILE* fp = fopen(fn, "r");
			fscanf(fp, "%s %s %lf", &ao, &t, &aomf1);
			fclose(fp);
			FILE* fp2 = fopen(fn2, "r");
			fscanf(fp2, "%s %s %lf", &ao2, &t, &aomf2);
			fclose(fp2);
			b1 = aomf1 - aom;
			if (b1 == aomf1)
			{
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s tried to transfer %.2f to %s\n\n", an, aom, ana);
				fclose(fpl);
				printf("Something went wrong, account balance is %.2f", b1);
				Sleep(2000);
				system("cls");
				goto menu;
			}
			if (b1 < 0)
			{
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s tried to transfer %.2f to %s\n\n", an, aom, ana);
				fclose(fpl);
				printf("You don't have enough money");
				Sleep(2000);
				system("cls");
				goto menu;
			}
			b2 = aomf2 + aom;
			if (b2 == aomf2)
			{
				FILE* fpl = fopen("logs.txt", "a");
				time_t date = time(0);
				fprintf(fpl, "%s", asctime(localtime(&date)));
				fprintf(fpl, "  Acc %s tried to transfer %.2f to %s\n\n", an, aom, ana);
				fclose(fpl);
				printf("Something went wrong, account balance is %.2f", b2);
				Sleep(2000);
				system("cls");
				goto menu;
			}
			FILE* fpn = fopen(fn, "w");
			fprintf(fpn, "%s\n  Balance: %.2f", ao, b1);
			FILE* fpn2 = fopen(fn2, "w");
			fprintf(fpn2, "%s\n  Balance: %.2f", ao2, b2);
			fclose(fpn);
			fclose(fpn2);
			FILE* fpl = fopen("logs.txt", "a");
			time_t date = time(0);
			fprintf(fpl, "%s", asctime(localtime(&date)));
			fprintf(fpl, "  Acc %s transfered %.2f to %s\n\n", an, aom, ana);
			fclose(fpl);
			printf("Operation completed. There is %.2f on account %s and %.2f on account %s",b1,an,b2,ana);
			Sleep(3000);
			system("cls");
			goto menu;
		}
		default:
			system("cls");
			goto menu;
		}
	}

}
int anc(char anf[])  //function to check if given account number consists of only digits anc - account number checker anf - account number in function
{
	int i = 0;
	while (i < 6)
	{
		if (anf[i] < 48 || anf[i]>57)
		{
			printf("\n  Invalid character detected, account number have to consist of 6 digits from 0-9\n\n");
			Sleep(1000);
			system("cls");
			return 1;
		}
		++i;
	
	}
	return 0;
}
int aec(char anf2[], int teone) //function to check if given account exists //anf - account number in function //teone - to exist or not exist
{
	char ntc[11]; //name to check
	sprintf(ntc, "%s.txt", anf2);  
	FILE* nc = fopen(ntc, "r");
	if (nc == NULL && teone == 1)
	{
		printf("Account does not exist, select another account");
		Sleep(1000);
		system("cls");
		return 1;
	}
	if (nc != (NULL) && teone == 0)
	{
		fclose(nc);
		printf("Account exist, select another combination");
		Sleep(1000);
		system("cls");
		return 0;
	}
	if (nc != (NULL) && teone == 1)	fclose(nc);
	printf("Please wait, operation in progress");
	Sleep(1000);
	system("cls");
	return 2;
}
int admm(int admc) //admin mode check 
{

	if (admc == 0)
	{
		printf("  You need to be an administrator in order to perform this operation");
		Sleep(1500);
		system("cls");
		return 0;
	}
	if (admc == 1)
	{
		return 1;
	}
	printf("ERROR");
	Sleep(1000);
	system("cls");
	return 2;
}