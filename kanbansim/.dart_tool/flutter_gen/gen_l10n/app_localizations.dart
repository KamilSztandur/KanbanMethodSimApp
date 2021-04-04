
import 'dart:async';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  // ignore: unused_field
  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @newSession.
  ///
  /// In en, this message translates to:
  /// **'New session'**
  String get newSession;

  /// No description provided for @createEmptySession.
  ///
  /// In en, this message translates to:
  /// **'Create empty session'**
  String get createEmptySession;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select template'**
  String get selectTemplate;

  /// No description provided for @saveSession.
  ///
  /// In en, this message translates to:
  /// **'Save session'**
  String get saveSession;

  /// No description provided for @loadSession.
  ///
  /// In en, this message translates to:
  /// **'Load session'**
  String get loadSession;

  /// No description provided for @addRandomTasks.
  ///
  /// In en, this message translates to:
  /// **'Add random tasks'**
  String get addRandomTasks;

  /// No description provided for @resetSession.
  ///
  /// In en, this message translates to:
  /// **'Reset session'**
  String get resetSession;

  /// No description provided for @themeSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch theme'**
  String get themeSwitch;

  /// No description provided for @langSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get langSwitch;

  /// No description provided for @polishLang.
  ///
  /// In en, this message translates to:
  /// **'Polish language'**
  String get polishLang;

  /// No description provided for @englishLang.
  ///
  /// In en, this message translates to:
  /// **'English language'**
  String get englishLang;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// No description provided for @newSessionNotif.
  ///
  /// In en, this message translates to:
  /// **'Creating empty session...'**
  String get newSessionNotif;

  /// No description provided for @selectingTemplateNotif.
  ///
  /// In en, this message translates to:
  /// **'Selecting template...'**
  String get selectingTemplateNotif;

  /// No description provided for @addRandomTasksSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully added few random tasks.'**
  String get addRandomTasksSuccess;

  /// No description provided for @resetSessionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully reseted current session.'**
  String get resetSessionSuccess;

  /// No description provided for @themeSwitchSuccess.
  ///
  /// In en, this message translates to:
  /// **'Theme switched successfully.'**
  String get themeSwitchSuccess;

  /// No description provided for @langSwitchSuccess.
  ///
  /// In en, this message translates to:
  /// **'Language switched successfully.'**
  String get langSwitchSuccess;

  /// No description provided for @openingHelpGuide.
  ///
  /// In en, this message translates to:
  /// **'Opening help guide...'**
  String get openingHelpGuide;

  /// No description provided for @applicationLegalese.
  ///
  /// In en, this message translates to:
  /// **'For education purposes only.\nDeveloped by Kamil Sztandur.\nContact: kamil.sztandur@vp.pl.'**
  String get applicationLegalese;

  /// No description provided for @applicationName.
  ///
  /// In en, this message translates to:
  /// **'Kanban Method\'s simulator'**
  String get applicationName;

  /// No description provided for @productivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get productivity;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @locks.
  ///
  /// In en, this message translates to:
  /// **'Locks'**
  String get locks;

  /// No description provided for @userInfo.
  ///
  /// In en, this message translates to:
  /// **'User status'**
  String get userInfo;

  /// No description provided for @locksArePresent.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get locksArePresent;

  /// No description provided for @noLocksArePresent.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get noLocksArePresent;

  /// No description provided for @switchToNextDaySuccess.
  ///
  /// In en, this message translates to:
  /// **'Switched to next day successfully.'**
  String get switchToNextDaySuccess;

  /// No description provided for @switchToPreviousDaySuccess.
  ///
  /// In en, this message translates to:
  /// **'Switched to previous day successfully.'**
  String get switchToPreviousDaySuccess;

  /// No description provided for @previousDaysLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Previous day\'s limit reached. Cannot switch more.'**
  String get previousDaysLimitReached;

  /// No description provided for @nextDaysLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Next day\'s limit reached. Cannot switch more.'**
  String get nextDaysLimitReached;

  /// No description provided for @availableTasks.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE TASKS'**
  String get availableTasks;

  /// No description provided for @stageOneTasks.
  ///
  /// In en, this message translates to:
  /// **'STAGE ONE TASKS'**
  String get stageOneTasks;

  /// No description provided for @inProgressTasks.
  ///
  /// In en, this message translates to:
  /// **'IN PROGRESS'**
  String get inProgressTasks;

  /// No description provided for @doneTasks.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get doneTasks;

  /// No description provided for @stageTwoTasks.
  ///
  /// In en, this message translates to:
  /// **'STAGE TWO TASKS'**
  String get stageTwoTasks;

  /// No description provided for @finishedTasks.
  ///
  /// In en, this message translates to:
  /// **'FINISHED TASKS'**
  String get finishedTasks;

  /// No description provided for @createNewTask.
  ///
  /// In en, this message translates to:
  /// **'CREATE NEW TASK'**
  String get createNewTask;

  /// No description provided for @setTitle.
  ///
  /// In en, this message translates to:
  /// **'Set title'**
  String get setTitle;

  /// No description provided for @assignTaskTo.
  ///
  /// In en, this message translates to:
  /// **'Assign task to'**
  String get assignTaskTo;

  /// No description provided for @setTaskTypeAs.
  ///
  /// In en, this message translates to:
  /// **'set task\'s type as'**
  String get setTaskTypeAs;

  /// No description provided for @setRequiredProductivity.
  ///
  /// In en, this message translates to:
  /// **'Set required productivity'**
  String get setRequiredProductivity;

  /// No description provided for @setDeadline.
  ///
  /// In en, this message translates to:
  /// **'Set task deadline day\'s number:'**
  String get setDeadline;

  /// No description provided for @deadlineAvailabilityNotice.
  ///
  /// In en, this message translates to:
  /// **'Available only for Fixed Date tasks!'**
  String get deadlineAvailabilityNotice;

  /// No description provided for @enterDeadlineDayNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter deadline day number'**
  String get enterDeadlineDayNumber;

  /// No description provided for @enterTaskTitleHere.
  ///
  /// In en, this message translates to:
  /// **'Enter your task title here'**
  String get enterTaskTitleHere;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @expedite.
  ///
  /// In en, this message translates to:
  /// **'Expedite'**
  String get expedite;

  /// No description provided for @fixedDate.
  ///
  /// In en, this message translates to:
  /// **'Fixed Date'**
  String get fixedDate;

  /// No description provided for @taskCreationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task created successfully!'**
  String get taskCreationSuccess;

  /// No description provided for @loadSavefile.
  ///
  /// In en, this message translates to:
  /// **'LOAD SAVED SESSION'**
  String get loadSavefile;

  /// No description provided for @loadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Save loading failed.'**
  String get loadingFailed;

  /// No description provided for @fileCorruptedNotice.
  ///
  /// In en, this message translates to:
  /// **'File corrupted or deleted.'**
  String get fileCorruptedNotice;

  /// No description provided for @loadFile.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get loadFile;

  /// No description provided for @selectFileToLoad.
  ///
  /// In en, this message translates to:
  /// **'Select file to load'**
  String get selectFileToLoad;

  /// No description provided for @availableSaves.
  ///
  /// In en, this message translates to:
  /// **'Available saves'**
  String get availableSaves;

  /// No description provided for @simulation.
  ///
  /// In en, this message translates to:
  /// **'Simulation'**
  String get simulation;

  /// No description provided for @filenameTaken.
  ///
  /// In en, this message translates to:
  /// **'Filename already taken.'**
  String get filenameTaken;

  /// No description provided for @invalidFilename.
  ///
  /// In en, this message translates to:
  /// **'Invalid filename.'**
  String get invalidFilename;

  /// No description provided for @savingSuccess.
  ///
  /// In en, this message translates to:
  /// **'saved successfully.'**
  String get savingSuccess;

  /// No description provided for @saveCurrentSession.
  ///
  /// In en, this message translates to:
  /// **'SAVE CURRENT SESSION'**
  String get saveCurrentSession;

  /// No description provided for @enterSaveNameHere.
  ///
  /// In en, this message translates to:
  /// **'Enter your savefile name here.'**
  String get enterSaveNameHere;

  /// No description provided for @filenameLabel.
  ///
  /// In en, this message translates to:
  /// **'Filename'**
  String get filenameLabel;

  /// No description provided for @generateAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Generate automatically'**
  String get generateAutomatically;

  /// No description provided for @assignUserToUnlockTask.
  ///
  /// In en, this message translates to:
  /// **'ASSIGN USER TO UNLOCK TASK'**
  String get assignUserToUnlockTask;

  /// No description provided for @productivityRequired.
  ///
  /// In en, this message translates to:
  /// **'productivity required'**
  String get productivityRequired;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @assignUserNotice.
  ///
  /// In en, this message translates to:
  /// **'If certain user isn\'t on the list it means either they are owner of this task or do not have enough productivity.'**
  String get assignUserNotice;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @unlockSuccess.
  ///
  /// In en, this message translates to:
  /// **'unlocked successfully!'**
  String get unlockSuccess;

  /// No description provided for @newTaskAppeared.
  ///
  /// In en, this message translates to:
  /// **'New task appeared'**
  String get newTaskAppeared;

  /// No description provided for @taskLocked.
  ///
  /// In en, this message translates to:
  /// **'Task got locked'**
  String get taskLocked;

  /// No description provided for @notice.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get notice;

  /// No description provided for @errorNotice.
  ///
  /// In en, this message translates to:
  /// **'Appliciation error'**
  String get errorNotice;

  /// No description provided for @elementDeleted.
  ///
  /// In en, this message translates to:
  /// **'Element deleted'**
  String get elementDeleted;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @copyLogsToClipboardhint.
  ///
  /// In en, this message translates to:
  /// **'Copy events logs to clipboard.'**
  String get copyLogsToClipboardhint;

  /// No description provided for @logsCopiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logs copied to clipboard successfully.'**
  String get logsCopiedSuccessfully;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {
  


// Lookup logic when only language code is specified.
switch (locale.languageCode) {
  case 'en': return AppLocalizationsEn();
    case 'pl': return AppLocalizationsPl();
}


  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
