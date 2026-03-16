
import '../models/injection_technique.dart';

final List<InjectionTechnique> injectionData = [
  // SHOULDER
  InjectionTechnique(
    id: 'shoulder-sasd',
    title: 'Subacromial–Subdeltoid Bursa Injection',
    category: 'Shoulder',
    tags: ['shoulder', 'subacromial', 'bursa', 'subdeltoid', 'impingement', 'rotator cuff'],
    treats: ['Shoulder impingement syndromes', 'Rotator cuff–related pain with bursitis', 'Primary or secondary subacromial–subdeltoid bursitis'],
    positioning: ['Patient supine; head of bed about 30°', 'Arm relaxed at the side; support forearm as needed'],
    probe: ['High‑frequency linear probe (6-13 MHz) (best for superficial structures)'],
    landmarking: [
      'Place the probe just anterior to the lateral acromial edge on top of the shoulder.',
      'Slide anterior ↔ posterior to identify the supraspinatus tendon as it passes under the acromion.',
      'Translate medially ↔ laterally to position the lateral acromion at screen edge while keeping supraspinatus in long‑axis.',
      'Identify the bursal plane: a thin dark stripe between the deltoid (superficial) and supraspinatus tendon (deep).'
    ],
    correctImage: ['Acromion at screen edge; supraspinatus fibers parallel and uniform', 'Bursal stripe widens slightly with gentle probe pressure'],
    corridor: ['Between deltoid (above) and supraspinatus tendon (below)—inject into the thin bursal stripe'],
    avoid: ['Cephalic vein near anterior deltoid', 'Intratendinous rotator cuff injection'],
    steps: [
      'Use an in‑plane anterolateral → posteromedial approach to keep the entire needle visible.',
      'Touch the bursal plane and inject a tiny test amount to confirm plane separation.',
      'Inject 4–8 mL while watching for smooth medial spread beneath the acromion.'
    ],
    tips: ['If you lose the needle, stop and realign before advancing', 'Adhesions may require gentle needle‑tip redirection'],
    pearls: [
      'Think of the bursa as a "potential space"—like a balloon that has been stepped on. It only opens up once you start injecting.',
      'Dissect the plane with local anesthetic first to confirm you are in the bursa before injecting steroid.',
      'Check for a "bursogram" post-injection; if injectate is in the tendon, it suggests a rotator cuff tear.',
      'The bursa extends beyond the supraspinatus footprint—use this to differentiate layers.'
    ],
    supplies: [
      '3cc/5cc Syringe',
      '25G 1.5" Needle (or 22G for larger patients)',
      '18G Drawing Needle',
      '1% Lidocaine (4–8 mL)',
      '1cc Kenalog (40mg/ml) or Dexamethasone',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
    // To add real pictures, just place them in assets/images/ and add the path here:
    // positioningImg: 'assets/images/shoulder_pos.jpg',
    // probeImg: 'assets/images/shoulder_probe.jpg',
    // landmarkImg: 'assets/images/shoulder_landmark.jpg',
    // ultrasoundImg: 'assets/images/shoulder_ultrasound.jpg',
  ),
  InjectionTechnique(
    id: 'shoulder-gh-posterior',
    title: 'Glenohumeral Joint Injection (Posterior Approach)',
    category: 'Shoulder',
    tags: ['shoulder', 'glenohumeral', 'posterior', 'labrum', 'capsule', 'adhesive capsulitis'],
    treats: ['Adhesive capsulitis', 'Glenohumeral osteoarthritis/synovitis', 'Diagnostic intra‑articular anesthesia'],
    positioning: ['Lateral decubitus; affected shoulder up; arm relaxed in neutral'],
    probe: ['Curvilinear preferred for a steeper, controllable needle angle (linear acceptable if needed)'],
    landmarking: [
      'Place the probe along the spine of the scapula to find the flat bright bony line.',
      'Slide inferiorly off the spine to visualize the infraspinatus muscle.',
      'Slide laterally until the humeral head faces the glenoid rim with the bright triangular labrum.',
      'Tilt (“fan”) to open the thin dark joint space between cartilage and capsule.'
    ],
    correctImage: ['Humeral head in lower third; glenoid rim medially; continuous dark intra‑articular line'],
    corridor: ['Through infraspinatus (entry) → subcapsular space just superficial to humeral head cartilage (target)'],
    avoid: ['Axillary nerve/arterial branches medially/inferiorly—stay lateral with a steep trajectory', 'Intralabral needle placement'],
    steps: [
      'Advance in‑plane from posterolateral → anteromedial at a steep angle.',
      'Contact capsule and inject a test bolus to confirm capsular lift.',
      'Inject 4–10 mL; gently rotate the shoulder to confirm intra‑articular spread.'
    ],
    tips: ['Steeper angles are easier to correct than shallow ones'],
    pearls: [
      'Steeper is better: it is easier to shallow out an angle than to correct one that is too medial.',
      'The needle naturally pulls medially as it passes the capsule—anticipate this.',
      'Perform internal/external rotation post-injection to confirm the iatrogenic effusion is intra-articular.'
    ],
    supplies: [
      '10cc Syringe',
      '22G 1.5" or 3.5" Spinal Needle',
      '18G Drawing Needle',
      '1% Lidocaine (5-10 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'shoulder-gh-anterior',
    title: 'Glenohumeral Joint Injection (Anterior Rotator Interval)',
    category: 'Shoulder',
    tags: ['shoulder', 'glenohumeral', 'anterior', 'rotator interval', 'biceps'],
    treats: ['Same as posterior approach; convenient when combining with subacromial injection'],
    positioning: ['Supine; head elevated ~30°; arm relaxed'],
    probe: ['High‑frequency linear probe (6-13 MHz)'],
    landmarking: [
      'Place probe transversely over anterior shoulder to locate the bicipital groove with the long head of the biceps.',
      'Rotate into long‑axis of the biceps tendon.',
      'Tilt slightly cephalad to visualize the rotator interval and capsule above the tendon.'
    ],
    correctImage: ['Biceps centered in groove; thin capsule above with potential dark joint space deep to capsule'],
    corridor: ['Under rotator‑interval capsule (above) along humeral head/neck (below)'],
    avoid: ['Branches of the anterior humeral circumflex artery—screen with Doppler if uncertain'],
    steps: ['Advance in‑plane beneath capsule into joint; confirm flow along intra‑articular biceps; inject 4–10 mL'],
    tips: ['You can treat SA/SD bursa and GH joint through one skin entry by syringe swap'],
    pearls: [
      'The needle courses through the subacromial bursa on the way to the rotator interval—allows "2-in-1" injection.',
      'Identify the coracohumeral ligament; the target is deep to this structure.'
    ],
    supplies: [
      '10cc Syringe',
      '22G 1.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (5-10 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'shoulder-ac',
    title: 'Acromioclavicular (AC) Joint Injection',
    category: 'Shoulder',
    tags: ['shoulder', 'ac joint', 'distal clavicle', 'sprain'],
    treats: ['AC joint arthritis/sprain', 'Distal clavicle osteolysis', 'Isolated AC pain'],
    positioning: ['Supine; head slightly elevated'],
    probe: ['High‑frequency linear probe (10-15 MHz)'],
    landmarking: ['Start mid‑clavicle; slide laterally to the gap; continue to acromion; translate to center the joint gap'],
    correctImage: ['Two flat bones (clavicle/acromion) with thin dark joint line centered'],
    corridor: ['Between superior capsule (below) and subcutaneous tissue (above) → tiny joint space'],
    avoid: ['Acromial branch of thoracoacromial artery; overfilling (very small capacity)'],
    steps: ['In‑plane anterior → posterior into joint; inject 0.5–1 mL and stop if resistance or pain rises'],
    tips: ['Use minimal local anesthetic to save space for steroid if used'],
    pearls: [
      'Don\'t "fill up" the joint with local if you plan to use steroid; the capacity is often < 1mL.',
      'If pressure is low, the capsule may be incompetent (post-trauma/surgery), leaking into SA space.',
      'Look for the Geyser sign: fluid tracking from GH joint up through the AC joint.'
    ],
    supplies: [
      '3cc Syringe',
      '25G or 27G 1" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (0.5–1 mL)',
      '0.5cc Kenalog or Dexamethasone',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'shoulder-biceps',
    title: 'Long Head of the Biceps Tendon Sheath Injection',
    category: 'Shoulder',
    tags: ['shoulder', 'biceps', 'sheath', 'tenosynovitis'],
    treats: ['Biceps tendon sheath inflammation', 'Diagnostic sheath injection'],
    positioning: ['Supine; head elevated; forearm supinated (palm up)'],
    probe: ['High‑frequency linear probe (6-13 MHz) (short footprint helpful)'],
    landmarking: [
      'Place probe transversely over proximal humerus; sweep medially into bicipital groove.',
      'Confirm tendon by rocking—moves as a single unit in the groove.',
      'Survey with Doppler for anterior humeral circumflex artery or variants crossing the sheath.'
    ],
    correctImage: ['Round/oval tendon centered in groove; thin dark rim around it = sheath'],
    corridor: ['Lateral → medial path into the thin dark rim around tendon (not intratendinous)'],
    avoid: ['Arterial variants; intratendinous steroid'],
    steps: ['Advance in‑plane; inject a tiny test amount for circumferential “target sign”; inject 3–4 mL once confirmed'],
    tips: ['If fluid collects above tendon or into SA space, you are in the wrong layer—readjust before steroid'],
    pearls: [
      'Create a "test effusion" with local to confirm circumferential spread around the tendon.',
      'The ascending branch of the anterior humeral circumflex artery typically lies lateral in the groove—check with Doppler.'
    ],
    supplies: [
      '5cc Syringe',
      '25G 1.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (3-4 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),

  // ELBOW
  InjectionTechnique(
    id: 'elbow-radiocapitellar',
    title: 'Radiocapitellar Joint Injection (Lateral Elbow)',
    category: 'Elbow',
    tags: ['elbow', 'radiocapitellar', 'arthritis', 'synovitis'],
    treats: ['Elbow arthritis', 'Lateral elbow joint pain', 'Synovitis/effusion', 'Diagnostic anesthetic'],
    positioning: ['Supine; elbow flexed 20–40°; hand on abdomen; small pillow under elbow'],
    probe: ['High‑frequency linear probe (6-13 MHz)'],
    landmarking: ['Find lateral epicondyle → slide distally to radial head → tilt anteriorly to view capitellum → identify wedge‑shaped joint space'],
    correctImage: ['Clear radial head–capitellum interface with a thin dark joint space'],
    corridor: ['Posterior → anterior path between triceps expansion/skin (above) and radial head/capitellum (below)'],
    avoid: ['Variants (vessels/nerves) — scan first'],
    steps: ['Out‑of‑plane posterior entry; gentle walk‑down to joint; test inject; inject 2–4 mL'],
    tips: ['Advance in small increments to avoid bone contact; if no expansion with test inject, adjust depth'],
    pearls: [
      'Visual Orientation: Think of the joint as a "cleft" between two hills. The capitellum is the rounded hill, and the radial head is the flatter hill.',
      'Use the "Walkdown" technique for this out-of-plane approach: touch the bone superficially first, then gently "walk" the needle tip down the slope into the joint.',
      'Pronate/supinate the forearm to confirm the radial head moves while the lateral epicondyle stays stationary.'
    ],
    supplies: [
      '5cc Syringe',
      '22G or 25G 1.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (2-4 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'elbow-cet',
    title: 'Common Extensor Tendon Origin Injection (Lateral Epicondyle)',
    category: 'Elbow',
    tags: ['elbow', 'tennis elbow', 'CET'],
    treats: ['Lateral epicondylitis with tendon surface pain or degeneration'],
    positioning: ['Supine; elbow 20–40° flexed; hand on abdomen'],
    probe: ['High‑frequency linear probe (6-13 MHz)'],
    landmarking: [
      'Probe over lateral epicondyle → identify bright fibrillar tendon footprint → note radial collateral ligament deep (30–50%) → map radial nerve and radial recurrent artery'
    ],
    correctImage: ['Crisp fibrillar tendon superficial to thin bright ligament band'],
    corridor: ['Distal → proximal path between skin/fat (above) and tendon surface (below) for steroid/peritendinous'],
    avoid: ['Radial nerve', 'Radial recurrent artery', 'Intratendinous steroid'],
    steps: ['In‑plane distal → proximal; position superficial to tendon; inject small aliquots along footprint'],
    tips: ['For regenerative injectates, target intratendinous diseased zones; avoid steroid in fibers'],
    pearls: [
      'The radial collateral ligament is deep—forming the deep 30–50% of this region.',
      'Avoid placing corticosteroid directly into the tendon fibers to prevent future rupture.'
    ],
    supplies: [
      '3cc Syringe',
      '25G or 27G 1" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (1-2 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'elbow-cfet',
    title: 'Common Flexor Tendon Origin Injection (Medial Epicondyle)',
    category: 'Elbow',
    tags: ['elbow', 'golfer elbow', 'CFET'],
    treats: ['Medial epicondylitis with pain at flexor origin'],
    positioning: ['Supine; arm slightly abducted/external rotation; elbow ~20°; forearm supinated'],
    probe: ['High‑frequency linear probe (6-13 MHz)'],
    landmarking: [
      'Locate medial epicondyle → slide distally to visualize fibrillar flexor tendon → rock posteriorly to find ulnar nerve → survey median nerve and brachial artery anteriorly'
    ],
    correctImage: ['Fibrillar tendon superficial to trochlea/ulna; ulnar nerve identified posterior to epicondyle'],
    corridor: ['Distal → proximal path between skin/fat (above) and tendon surface (below) for steroid/peritendinous'],
    avoid: ['Ulnar nerve (may sublux anteriorly)', 'Median nerve', 'Brachial artery'],
    steps: ['In‑plane distal → proximal to tendon surface; inject small aliquots to form peritendinous halo'],
    tips: ['If approaching proximal → distal, re‑confirm ulnar nerve immediately pre‑entry'],
    pearls: [
      'The ulnar nerve is often posterior to the medial epicondyle but can sublux over the top—always locate it first.',
      'Identify the median nerve and brachial artery during pre-procedure scanning to ensure clear path.'
    ],
    supplies: [
      '3cc Syringe',
      '25G or 27G 1" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (1-2 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),

  // WRIST & HAND
  InjectionTechnique(
    id: 'wrist-carpal',
    title: 'Carpal Tunnel Injection',
    category: 'Hand',
    tags: ['wrist', 'carpal tunnel', 'median nerve'],
    treats: ['Median nerve compression (carpal tunnel syndrome)'],
    positioning: ['Seated preferred (or supine if vasovagal); forearm supinated; wrist slightly extended'],
    probe: ['High‑frequency linear probe; short footprint helpful'],
    landmarking: [
      'Probe transversely at proximal wrist crease → identify median nerve under retinaculum → identify flexor tendons → map ulnar bundle → check for bifid nerve/persistent median artery'
    ],
    correctImage: ['Median nerve centered; retinaculum as bright roof; adequate perineural space'],
    corridor: ['Ulnar → radial path under retinaculum beside the median nerve (hydrodissect above/below nerve if safe)'],
    avoid: ['Ulnar nerve/artery', 'Persistent median artery', 'Intraneural injection'],
    steps: ['In‑plane ulnar entry; position beside nerve; inject 1–2 mL to create circumferential target‑sign spread'],
    tips: ['Use low volume; confirm small fluid rings around nerve'],
    pearls: [
      'The "Oven Mitt" rule: The Flexor Retinaculum is like a tight oven mitt holding everything in. Your goal is to slide the needle *under* the mitt, not into the hand (nerve).',
      'Create a "Target Sign": hydrodissect both above and below the nerve for circumferential spread.',
      'Check for a bifid median nerve or persistent median artery; don\'t go through the artery!',
      'Ulnar approach is preferred to stay clear of the radial neurovascular bundle.'
    ],
    supplies: [
      '3cc/5cc Syringe',
      '25G or 27G 1.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (2-5 mL)',
      '1cc Kenalog or Dexamethasone',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'wrist-dequervain',
    title: 'First Dorsal Compartment Injection (De Quervain’s)',
    category: 'Hand',
    tags: ['wrist', 'de quervain', 'APL', 'EPB'],
    treats: ['De Quervain’s tenosynovitis (APL/EPB)'],
    positioning: ['Seated or supine; forearm neutral; thumb up'],
    probe: ['High‑frequency linear probe (6-13 MHz)'],
    landmarking: [
      'Place probe over the radial styloid (the bony bump on the thumb side of the wrist) in short‑axis.',
      'Identify APL/EPB tendons (they look like two small eyes in a single socket).',
      'Look for a vertical septum (a wall) between them.',
      'Map superficial radial nerve branches to avoid them.'
    ],
    correctImage: ['Two tendons within sheath; septum visible if present'],
    corridor: ['Often volar → dorsal path into sheath: skin/fat (above), sheath (below)'],
    avoid: ['Superficial radial nerve', 'Radial artery (deep/volar)'],
    steps: ['In‑plane into sheath; inject 2–3 mL; ensure spread around BOTH tendons; redirect past septum if needed'],
    tips: ['Always identify superficial radial nerve first and adjust approach'],
    pearls: [
      'A vertical septum (sub-compartmentalization) is common; you MUST ensure spread around BOTH tendons.',
      'Use a short 27G needle for better control in this superficial space.',
      'Wrist in neutral to slight ulnar deviation avoids anisotropy artifacts.'
    ],
    supplies: [
      '3cc Syringe',
      '27G 0.5" or 1" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (2-3 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'hand-1stmcp',
    title: 'First Metacarpophalangeal (MCP) Joint Injection (Thumb Base)',
    category: 'Hand',
    tags: ['hand', 'MCP', 'thumb', 'arthritis'],
    treats: ['Thumb MCP arthritis or synovitis'],
    positioning: ['Hand supported flat; palm down'],
    probe: ['High‑frequency linear probe'],
    landmarking: ['Dorsal probe over MCP → identify metacarpal head and proximal phalanx → thin dark line between = joint space → map tiny dorsal vessels with Doppler'],
    correctImage: ['Parallel cartilage surfaces with thin anechoic joint line'],
    corridor: ['Dorsal in‑plane approach parallel to cartilage surfaces'],
    avoid: ['Digital arteries and dorsal sensory branches'],
    steps: ['Advance in‑plane into joint; inject up to 1 mL slowly'],
    tips: ['Tiny joint—advance delicately and stay parallel to cartilage'],
    pearls: [
      'Identify the 1st CMC joint by sliding distal to the radial styloid; avoid the radial artery.',
      'The target is the "joint gap"—confirm flow with capsular distension.',
      'Limited volume: don\'t waste space with too much local first.'
    ],
    supplies: [
      '3cc Syringe',
      '27G 0.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (0.5–1 mL)',
      '0.5cc Kenalog or Dexamethasone',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),

  // HIP
  InjectionTechnique(
    id: 'hip-anterior',
    title: 'Anterior Intra‑articular Injection (Femoral Head–Neck Junction)',
    category: 'Hip',
    tags: ['hip', 'intra-articular', 'iliopsoas', 'lfca'],
    treats: ['Hip osteoarthritis', 'Labral irritation', 'Diagnostic anesthetic'],
    positioning: ['Supine; hip neutral (often ~20° abduction)'],
    probe: ['Low‑frequency curvilinear probe (2-5 MHz)'],
    landmarking: [
      'Probe transversely at groin → rotate to align with head–neck junction (oblique) → identify capsule and iliopsoas → scan medially for femoral NV bundle and LFCA branch'
    ],
    correctImage: ['Round head narrowing into neck; thin capsule; iliopsoas superficial'],
    corridor: ['Inferolateral → superomedial under iliopsoas (above) to capsule at head–neck junction (below)'],
    avoid: ['Femoral nerve/artery/vein medially', 'Ascending branch of lateral femoral circumflex artery'],
    steps: ['In‑plane to capsule; test inject to lift capsule; complete injection as indicated'],
    tips: ['Continuously track needle tip; small tilts help follow it through iliopsoas'],
    pearls: [
      'Visualizing Depth: Use a spinal needle (22G 3.5") for adults; the depth can be surprising. If the needle disappears, use a slight "jiggle" to find it in the iliopsoas.',
      'Scan the femoral head-neck junction using an oblique transverse plane.',
      'Identify the ascending branch of the lateral femoral circumflex artery with Doppler before entry.',
    ],
    supplies: [
      '10cc Syringe',
      '22G 3.5" Spinal Needle',
      '18G Drawing Needle',
      '1% Lidocaine (5-10 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'hip-gtb',
    title: 'Greater Trochanteric Bursa Injection',
    category: 'Hip',
    tags: ['hip', 'gt bursa', 'gluteus medius', 'it band'],
    treats: ['Greater trochanteric pain syndrome (bursal inflammation)'],
    positioning: ['Side‑lying, symptomatic side up'],
    probe: ['Linear or curvilinear depending on habitus'],
    landmarking: [
      'Probe on lateral hip → identify bright convex greater trochanter → slide posteriorly to gluteus medius tendon → find dark plane between IT band/GMx (superficial) and gluteus medius tendon (deep)'
    ],
    correctImage: ['Distinct dark plane separating superficial IT band/GMx from deep gluteus medius tendon'],
    corridor: ['Posterior → anterior into bursal plane: IT band/GMx (above), gluteus medius tendon (below)'],
    avoid: ['Typically no major NV structures, but survey for variants'],
    steps: ['In‑plane into bursal plane; inject 4–10 mL until plane opens and spreads laterally'],
    tips: ['Slight rotation in line with GMx fibers may increase conspicuity'],
    pearls: [
      'The bursa is the hypoechoic plane between the IT band and the gluteus medius tendon.',
      'Rotate the probe to align with Glute Maximus fibers to see the bursa more clearly.',
      'Ensure the IT band "lifts off" the tendon during injection.'
    ],
    supplies: [
      '10cc Syringe',
      '22G 1.5" or 3.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (5-10 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'hip-piriformis',
    title: 'Piriformis Injection',
    category: 'Hip',
    tags: ['hip', 'piriformis', 'sciatic nerve', 'deep gluteal pain'],
    treats: ['Piriformis syndrome with sciatic irritation', 'Deep gluteal pain / non‑spinal sciatica'],
    positioning: ['Prone with neutral pelvis; pillow under iliac crests to improve visualization'],
    probe: ['Curvilinear probe (2-5 MHz) for depth; low‑frequency linear in thin patients'],
    landmarking: [
      'Probe over PSIS → slide inferior to see sacrum medially and PIIS laterally',
      'Continue distally until ilium disappears (greater sciatic notch)',
      'Identify piriformis deep to gluteus maximus, coursing sacrum → greater trochanter',
      'Internally/externally rotate hip to confirm piriformis motion',
      'Identify sciatic nerve deep/inferior to piriformis before injection'
    ],
    correctImage: ['Gluteus maximus superficial; fusiform piriformis belly oblique; sciatic nerve deep (honeycomb)'],
    corridor: ['Between gluteus maximus (above) and piriformis (below); avoid sciatic nerve'],
    avoid: ['Sciatic nerve; inferior gluteal vessels (use Doppler initially)'],
    steps: [
      'Advance in‑plane (lateral → medial) under real‑time US',
      'Stop at piriformis belly or perifascial plane; aspirate gently',
      'Test inject a small bolus; then inject anesthetic ± steroid or botulinum toxin as indicated'
    ],
    tips: ['Map vessels with Doppler; if nerve not clearly visualized, do not inject'],
    pearls: [
      'The sciatic nerve is usually deep to the piriformis belly—always identify it first.',
      'Confirm the piriformis muscle by having the patient internally/externally rotate the hip.',
      'Approach lateral-to-medial to keep the needle away from the sciatic notch.'
    ],
    supplies: [
      '10cc Syringe',
      '22G 3.5" Spinal Needle',
      '18G Drawing Needle',
      '1% Lidocaine (5-10 mL)',
      '1cc Kenalog or Botulinum toxin',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'si-joint',
    title: 'Sacroiliac (SI) Joint Injection',
    category: 'Hip',
    tags: ['hip', 'si joint', 'sacroiliac', 'low back pain', 'diagnostic injection'],
    treats: ['Suspected SIJ‑mediated pain (diagnostic gold standard)', 'Therapeutic injection after failed conservative care'],
    positioning: ['Prone; pillow under abdomen to minimize lumbar lordosis'],
    probe: ['Curvilinear 2-5 MHz; linear may suffice in thin patients'],
    landmarking: [
      'Method 1: Transverse over sacral hiatus to see cornua → move laterally to sacral edge → follow cephalad until ilium appears → cleft between = SIJ',
      'Method 2: Find sacral ala → translate laterally to posterior SI region → tilt/rock to visualize synovial cleft (often inferiorly)'
    ],
    correctImage: ['Two bony lines (sacrum medial, ilium lateral) with a cleft between; posterior ligaments superficial'],
    corridor: ['In‑plane lateral → medial through posterior ligaments into synovial cleft (inferior half most accessible)'],
    avoid: ['Dorsal sacral foramina medially; gluteal vessels/nerves laterally'],
    steps: [
      'Advance in‑plane to joint cleft; test inject a small bolus for separation',
      'Inject therapeutic volume (often ~1–2 mL) under real‑time visualization'
    ],
    tips: ['Success improves with experience; aim for inferior synovial region if cleft is narrowed in older adults'],
    pearls: [
      'Approach lateral-to-medial through the posterior ligaments.',
      'The inferior synovial cleft is the most reproducible entry point.',
      'Confirm positioning by visualizing the cleft opening during test bolus.'
    ],
    supplies: [
      '5cc Syringe',
      '22G 1.5" or 3.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (2-3 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),

  // KNEE
  InjectionTechnique(
    id: 'knee-suprapatellar',
    title: 'Suprapatellar Recess Injection',
    category: 'Knee',
    tags: ['knee', 'suprapatellar', 'recess', 'fat pad', 'prefemoral', 'quadriceps'],
    treats: ['Knee osteoarthritis', 'Synovitis/effusion', 'Diagnostic anesthetic'],
    positioning: ['Supine; small towel under knee for 20-30° flexion'],
    probe: ['High‑frequency linear probe (6-13 MHz)'],
    landmarking: [
      'Long‑axis over distal femur → identify femoral cortex → prefemoral fat pad above → suprapatellar recess (target) above that → quadriceps fat pad and quadriceps tendon above.',
      'Slide the probe laterally to find the deepest part of the recess for easier access.'
    ],
    correctImage: ['Two distinct fat pads with anechoic space between — quadriceps fat pad (above) and prefemoral fat pad (below).'],
    corridor: ['Lateral → medial in‑plane approach into the deepest part of the suprapatellar recess.'],
    avoid: ['Avoid traversing the quadriceps tendon or patellar tendon.', 'Genicular vessels (screen with Doppler).'],
    steps: [
      'Position patient supine with knee in 20-30° flexion.',
      'Place probe in long-axis (sagittal) over the suprapatellar region.',
      'Identify the anechoic effusion or the hypoechoic plane between fat pads.',
      'Advance in‑plane from the lateral side into the recess.',
      'Confirm spread with a small test bolus of local anesthetic.'
    ],
    tips: ['Gentle probe compression pools fluid at your entry site; keep needle parallel to cartilage'],
    pearls: [
      'The "Two-Pad" Sandwich: The target recess is the space between the Quadriceps Fat Pad (the top bun) and the Prefemoral Fat Pad (the bottom bun).',
      'Position the knee at 20–30° flexion to relax the quadriceps and "pool" fluid into the suprapatellar space.',
      'Approach lateral-to-medial: it keeps you away from sensitive medial structures and ensures the most perpendicular view of the needle.',
    ],
    supplies: [
      '10cc or 20cc Syringe',
      '21G or 22G 1.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (5-10 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),

  // ANKLE & FOOT
  InjectionTechnique(
    id: 'ankle-ttj',
    title: 'Tibiotalar (Ankle) Joint Injection',
    category: 'Foot',
    tags: ['ankle', 'tibiotalar', 'dorsalis pedis', 'deep peroneal'],
    treats: ['Ankle osteoarthritis', 'Synovitis', 'Diagnostic anesthetic'],
    positioning: ['Supine; knee ~90°; foot flat; ankle slightly plantarflexed'],
    probe: ['High‑frequency linear probe (6-13 MHz)'],
    landmarking: [
      'Probe on anterior ankle → identify curved talar dome → find thin capsular line above → map deep peroneal nerve and dorsalis pedis artery (deep to EHL)'
    ],
    correctImage: ['Identify the talar dome (curved line) with distinct dark capsular line above; tendons are superficial and out of path'],
    corridor: ['Medial → lateral path deep to anterior tendons (above) and superficial to capsule/cartilage (below)'],
    avoid: ['Deep peroneal nerve and dorsalis pedis artery; avoid traversing EHL if possible'],
    steps: ['In‑plane; hug capsule superficial to cartilage; inject as indicated; confirm intra‑articular distension'],
    tips: ['Small tilts separate capsule from cartilage and improve needle visualization'],
    pearls: [
      'Advance medial-to-lateral deep to the anterior tendons.',
      'Identify the deep peroneal nerve and dorsalis pedis artery; they lie just lateral to the EHL tendon.',
      'The target is the space between the joint capsule and the talar hyaline cartilage.'
    ],
    supplies: [
      '5cc Syringe',
      '25G 1.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (3-5 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'ankle-peroneal',
    category: 'Foot',
    title: 'Peroneal Tendon Sheath Injection',
    tags: ['ankle', 'peroneal', 'retinaculum', 'brevis', 'longus'],
    treats: ['Peroneal tendinopathy (peroneus longus/brevis)'],
    positioning: ['Side‑lying with symptomatic ankle up'],
    probe: ['High‑frequency linear probe (6-13 MHz) (short footprint ideal)'],
    landmarking: [
      'Probe over posterior aspect of lateral malleolus → identify peroneus longus and brevis tendons sharing a sheath → see superior peroneal retinaculum overlying'
    ],
    correctImage: ['Two tendons in shared anechoic rim (sheath) behind the fibula'],
    corridor: ['Anterior → posterior under retinaculum (above) into sheath around tendons (below)'],
    avoid: ['Sural nerve posteriorly (usually not in path, but confirm)'],
    steps: ['In‑plane into sheath; surround both tendons with injectate; redirect if only one tendon fills'],
    tips: ['Short needle gives fine control; low volumes suffice'],
    pearls: [
      'Approach anterior-to-posterior under the superior peroneal retinaculum.',
      'Ensure injectate surrounds both the longus and brevis tendons in their shared sheath.',
      'Always survey for the sural nerve posteriorly to ensure it\'s out of your path.'
    ],
    supplies: [
      '5cc Syringe',
      '25G 1.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (3-5 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'foot-plantar',
    category: 'Foot',
    title: 'Plantar Fascia (Perifascial) Injection',
    tags: ['foot', 'plantar fascia', 'calcaneus', 'heel', 'fat pad'],
    treats: ['Plantar fasciitis (heel pain) requiring perifascial therapy'],
    positioning: ['Side‑lying with symptomatic foot dependent or off table edge'],
    probe: ['High‑frequency linear probe (6-13 MHz)'],
    landmarking: [
      'Short‑axis over plantar heel at calcaneal origin → identify bright plantar fascia on calcaneus → find thin dark plane between fascia and fat pad'
    ],
    correctImage: ['Bright fascia with thin anechoic plane separating it from fat pad'],
    corridor: ['Medial → lateral within thin plane: fat pad (above), plantar fascia (below) — do not enter fascia'],
    avoid: ['Intrafascial steroid (rupture risk)', 'Injection into fat pad (atrophy risk)', 'Medial neurovascular bundle'],
    steps: ['In‑plane into plane; inject small volumes to expand plane without entering fascia'],
    tips: ['Use smallest effective volume; stop if resistance — correct plane opens smoothly'],
    pearls: [
      'The target is the hypoechoic plane between the fat pad (superficial) and fascia (deep).',
      'Avoid intrafascial or fat pad injection to prevent rupture or atrophy.',
      'Approach medial-to-lateral to avoid the medial neurovascular bundle.'
    ],
    supplies: [
      '5cc Syringe',
      '25G or 27G 1.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (3-5 mL)',
      '1cc Kenalog or Dexamethasone',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'hand-trigger-finger',
    title: 'Trigger Finger (A1 Pulley) Injection',
    category: 'Hand',
    tags: ['hand', 'trigger finger', 'A1 pulley', 'flexor tendon'],
    treats: ['Trigger finger (stenosing tenosynovitis)', 'Tendon locking/catching'],
    positioning: ['Hand supinated; arm on table; fingers extended'],
    probe: ['High‑frequency linear probe (6-13 MHz) (short footprint ideal)'],
    landmarking: [
      'Short-axis over the MCP head to identify the FDS/FDP tendons.',
      'The A1 pulley is the thickened hyperechoic band just superficial to the tendons.',
      'Use dynamic flexion/extension to witness "triggering" and tendon nodularity.'
    ],
    correctImage: ['Thickened A1 pulley centered over the round flexor tendons in short-axis.'],
    corridor: ['In-plane approach aiming for the space between the pulley and the tendon.'],
    avoid: ['Digital nerves/arteries on the radial/ulnar sides of the tendon.', 'Intratendinous injection.'],
    steps: [
      'Advance in-plane in short-axis.',
      'Direct the needle between the pulley and the tendon.',
      'Inject 1-2 mL; confirm synovial sheath distension.'
    ],
    tips: ['If you meet resistance, you are likely in the tendon—re-position.'],
    pearls: [
      'Dynamic visualization is diagnostic: look for disconjugate tendon motion or nodule catching.',
      'Injecting the synovial sheath is the goal; the steroid will track to the pulley.',
      'A short 27G needle provides the best precision for this superficial target.'
    ],
    supplies: [
      '3cc Syringe',
      '27G 0.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (1-2 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep / Ethyl Chloride spray',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'foot-mortons-neuroma',
    title: 'Morton\'s Neuroma Injection (Dorsal Approach)',
    category: 'Foot',
    tags: ['foot', 'morton\'s neuroma', 'metatarsal', 'web space'],
    treats: ['Interdigital neuralgia (Morton\'s neuroma)', 'Intermetatarsal bursitis'],
    positioning: ['Supine; foot resting on table; toes slightly flexed'],
    probe: ['High‑frequency linear probe (6-13 MHz)'],
    landmarking: [
      'Transverse over metatarsal heads to find the target web space (usually 2nd-3rd or 3rd-4th).',
      'Apply pressure (Mulder\'s Click maneuver) to displace the neuroma dorsally.',
      'Identify the hypoechoic "dumbbell" or round mass between metatarsal heads.'
    ],
    correctImage: ['Hypoechoic mass in the intermetatarsal space; metatarsal heads on either side.'],
    corridor: ['Dorsal in-plane approach directly into the intermetatarsal space.'],
    avoid: ['Deep plantar vessels.', 'Digital nerves.'],
    steps: [
      'Advance dorsal-to-plantar under real-time US.',
      'Target the center of the hypoechoic mass.',
      'Inject 2-3 mL; watch for fluid surrounding the neuroma.'
    ],
    tips: ['Dorsal approach is safer and avoids painful plantar weight-bearing skin.'],
    pearls: [
      'Use the plantar "squeeze test" (Mulder\'s maneuver) while scanning to confirm the neuroma pops up.',
      'Identify and avoid the intermetatarsal bursa, which may also be inflamed.',
      'Steroid in the plantar fat pad can cause atrophy—the dorsal approach minimizes this risk.'
    ],
    supplies: [
      '3cc Syringe',
      '27G 1" or 1.5" Needle',
      '18G Drawing Needle',
      '1% Lidocaine (2-3 mL)',
      '1cc Kenalog or Dexamethasone',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
  InjectionTechnique(
    id: 'hip-hamstring-proximal',
    title: 'Proximal Hamstring (Ischial Tuberosity) Injection',
    category: 'Hip',
    tags: ['hip', 'hamstring', 'ischial tuberosity', 'tendinopathy'],
    treats: ['Proximal hamstring tendinopathy', 'Ischiogluteal bursitis'],
    positioning: ['Prone; leg slightly abducted and neutral'],
    probe: ['Curvilinear probe (2-5 MHz) for depth.'],
    landmarking: [
      'Transverse over the gluteal fold to identify the bright curved ischial tuberosity.',
      'Identify the conjoined tendon (Biceps Femoris/Semitendinosus) originating from the lateral tuberosity.',
      'Locate the Sciatic Nerve lateral and posterior to the hamstring origin.'
    ],
    correctImage: ['Hyperechoic bony tuberosity with thick fibrillar tendon origin; Sciatic nerve clear laterally.'],
    corridor: ['In-plane lateral-to-medial or caudal-to-cranial approach.'],
    avoid: ['Sciatic nerve (lateral).', 'Inferior gluteal artery (Doppler survey).'],
    steps: [
      'Identify the sciatic nerve first and stay medial to it.',
      'Advance to the tendon origin or the bursa superficial to it.',
      'Inject 4-6 mL; confirm spread at the bone-tendon interface.'
    ],
    tips: ['A longer spinal needle (22G 3.5") is often required for the gluteal depth.'],
    pearls: [
      'The Sciatic Nerve is your "No-Fly Zone"—always keep it in view and stay medial.',
      'The ischial tuberosity shadows heavily; use this shadow to orient your depth.',
      'Differentiating between tendonopathy and ischiogluteal bursitis is key for therapeutic effect.'
    ],
    supplies: [
      '10cc Syringe',
      '22G 3.5" Spinal Needle',
      '18G Drawing Needle',
      '1% Lidocaine (5-8 mL)',
      '1cc Kenalog (40mg/ml)',
      'Alcohol Swabs (vial tops)',
      'Betadine/Chloraprep',
      'Sterile 4x4 Gauze Pads',
      'Sterile Towels & Drapes',
      'Adhesive Bandage (Band-Aid)',
      'Washcloth/Towel (gel cleanup)',
      'Needle Disposal Safety Cap',
      'Sterile probe cover & gel'
    ],
  ),
];
