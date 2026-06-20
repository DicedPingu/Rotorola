import '../../models/quiz.dart';

const List<QuizQuestion> quizQuestionsList = [
  QuizQuestion(
    question: 'Why does unlocking the bootloader perform a mandatory factory data reset?',
    options: [
      'To save storage space on the internal flash chip.',
      'To protect user data by preventing an unauthorized party from accessing encrypted files via custom recovery.',
      'Because the Android partition layout changes automatically.',
      'To clear the system cache and make the phone run faster.'
    ],
    correctIndex: 1,
    explanation: 'Android uses file-based encryption (FBE). If the bootloader could be unlocked without wiping the device, anyone could unlock your phone, boot into a custom recovery, and read all your private files. Wiping user data ensures that encryption keys are destroyed when security is modified.',
    category: 'Bootloader',
  ),
  QuizQuestion(
    question: 'What is the purpose of Zygisk in modern Magisk rooting?',
    options: [
      'It compiles custom kernel architectures during boot.',
      'It blocks fastboot commands on the device.',
      'It runs parts of Magisk directly inside the Zygote process, allowing modules to inject code into other apps.',
      'It disables security logs on the system.'
    ],
    correctIndex: 2,
    explanation: 'Zygote is the parent process from which all Android applications are spawned. Zygisk runs code inside the Zygote process, allowing modules to seamlessly customize system frameworks and applications before they even launch.',
    category: 'Root Architecture',
  ),
  QuizQuestion(
    question: 'What happens if you run "fastboot flashing lock" while running custom system files (e.g. root, TWRP, or a GSI)?',
    options: [
      'The phone will boot successfully and safely secure your modifications.',
      'The phone will enter a soft-loop but can be fixed by unlocking again.',
      'The phone will hard-brick because the secure boot signature check fails and locks you out of the bootloader.',
      'Nothing happens, as fastboot commands are disabled once rooted.'
    ],
    correctIndex: 2,
    explanation: 'This is the most critical rule of Android modding! Locking the bootloader forces the device to verify cryptographic signatures of all partitions (boot, recovery, system, vendor) against official OEM keys. If signature checks fail, secure boot locks down, turning your phone into a hard brick that cannot access fastboot or boot.',
    category: 'Safe Modding',
  ),
  QuizQuestion(
    question: 'Which partition contains the Android bootloader code that controls Fastboot and charging modes?',
    options: [
      'boot',
      'lk (Little Kernel)',
      'super',
      'preloader'
    ],
    correctIndex: 1,
    explanation: 'The `lk` (Little Kernel) partition contains the bootloader code responsible for initializing the display, button inputs, entering AP Fastboot mode, and displaying charging screens. Modifying it with payload tools (like `kaeru`) is how custom fastboot features are added.',
    category: 'Partition Tables',
  ),
  QuizQuestion(
    question: 'Why should you avoid using your primary Google Account on a rooted Android device?',
    options: [
      'Because Google bans primary accounts instantly upon detecting root access.',
      'Because the Play Store will refuse to download apps if you are signed in.',
      'To isolate your primary data and prevent potential access if a malicious app is accidentally granted root permissions.',
      'Rooted devices are unable to connect to Google servers.'
    ],
    correctIndex: 2,
    explanation: 'Google does not ban accounts for rooting, but rooting bypasses the Android sandbox. Keeping your primary data separate by using a secondary account or anonymous app clients (like Aurora Store) prevents a malicious superuser app from stealing credentials or private data.',
    category: 'Android Security',
  ),
];
